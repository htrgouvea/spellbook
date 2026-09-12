package Spellbook::Core::Graph {
    use strict;
    use warnings;
    use threads;
    use Thread::Queue;
    use threads::shared;
    use Readonly;
    use Mojo::File;
    use Mojo::JSON qw(decode_json encode_json);
    use Spellbook::Core::Module;
    use Spellbook::Core::Orchestrator;

    our $VERSION = '0.0.1';

    Readonly my $SIGIL       => q{@};
    Readonly my $ATTR_KEY    => "${SIGIL}attributes";
    Readonly my $EDGE_KEY    => "${SIGIL}edges";
    Readonly my $PAIR_FIELDS => 3;

    sub run_add {
        my ($scope, $options) = @_;
        my $graph   = _load($scope);
        my @results = _dispatch_add($graph, $options);

        _save($scope, $graph);

        return @results;
    }

    sub _dispatch_add {
        my ($graph, $options) = @_;
        my ($from, $to, $target, $value, $entrypoint, $tag, $pairs) =
            @{$options}{qw(from to target value entrypoint tag pairs)};

        if ($pairs && $entrypoint && $to) {
            return _add_pairs($graph, [$from, $to], $entrypoint, $options -> {keep});
        }

        if ($tag && $entrypoint) {
            return _classify($graph, $from, $entrypoint, $options -> {threads},
                { target => $target, key => $options -> {tag_key}, value => $options -> {tag_value} });
        }

        if ($target && $value && $to) {
            $graph -> {$from} -> {$target} //= {};
            _edge($graph, [$from, $target], [$to, $value], $options -> {attrs});
            return ("$target -> $value");
        }

        if (!$value && $target) {
            return _add($graph, [$from, $target], $to, $entrypoint,
                { attrs => $options -> {attrs}, keep => $options -> {keep} });
        }

        if (!$value && !$target && $to && $entrypoint) {
            return _add_bulk($graph, [$from, $to], $entrypoint, $options -> {threads}, $options -> {keep});
        }

        return ();
    }

    sub run_query {
        my ($scope, $options) = @_;
        my $from = $options -> {from};

        if ($options -> {show_attrs}) {
            return _query_attr($scope, $from, $options -> {target}, $options -> {to}, $options -> {value});
        }

        my @results = $options -> {where}
            ? _query_where($scope, $from, $options -> {where_key}, $options -> {where_value})
            : _query($scope, $from, $options -> {to}, $options -> {target});

        if ($options -> {entrypoint} && @results) {
            return Spellbook::Core::Orchestrator -> new([
                '--entrypoint' => $options -> {entrypoint},
                '--list'       => \@results,
                '--threads'    => $options -> {threads}
            ]);
        }

        return @results;
    }

    sub _add {
        my ($graph, $source, $to, $entrypoint, $options) = @_;
        my ($from, $target) = @{$source};
        my $attrs = $options -> {attrs};
        my $keep  = $options -> {keep};
        my @results;
        my @fresh;

        $graph -> {$from} -> {$target} //= {};

        if ($entrypoint && $to) {
            my @values = Spellbook::Core::Module -> new($entrypoint, ['--target' => $target]);

            foreach my $item (@values) {
                my ($to_value, $edge_attrs) = _coerce($item);
                _edge($graph, [$from, $target], [$to, $to_value], $edge_attrs);
                push @fresh, $to_value;
                push @results, "$target -> $to_value";
            }

            if (!$keep && @fresh) {
                _reset_source($graph, $from, $target, $to, \@fresh);
            }
        }

        if (!$entrypoint) {
            if ($attrs) {
                _node_attr($graph, $from, $target, $attrs);
            }

            push @results, $target;
        }

        return @results;
    }

    sub _reset_source {
        my ($graph, $from, $target, $to, $fresh) = @_;
        my %keep    = map { $_ => 1 } @{$fresh};
        my $current = $graph -> {$from} -> {$target} -> {$to} // [];

        foreach my $to_value (@{$current}) {
            next if $keep{$to_value};

            my $neighbor = $graph -> {$to} -> {$to_value};

            if ($neighbor && $neighbor -> {$from}) {
                @{$neighbor -> {$from}} = grep { $_ ne $target } @{$neighbor -> {$from}};
            }

            if ($neighbor && $neighbor -> {$EDGE_KEY} && $neighbor -> {$EDGE_KEY} -> {$from}) {
                delete $neighbor -> {$EDGE_KEY} -> {$from} -> {$target};
            }
        }

        @{$graph -> {$from} -> {$target} -> {$to}} = grep { $keep{$_} } @{$current};
        return 1;
    }

    sub parse_attrs {
        my ($pairs) = @_;

        if (!$pairs || !@{$pairs}) {
            return;
        }

        my %attrs;

        foreach my $pair (@{$pairs}) {
            my ($key, $value) = split /=/msx, $pair, 2;

            if (defined $key && length $key) {
                $attrs{$key} = defined $value ? $value : q{};
            }
        }

        return \%attrs;
    }

    sub _coerce {
        my ($item) = @_;

        if (ref $item eq 'HASH') {
            return ($item -> {'value'}, $item -> {'attributes'});
        }

        return ($item, undef);
    }

    sub _node_attr {
        my ($graph, $type, $value, $attrs) = @_;

        $graph -> {$type} -> {$value} -> {$ATTR_KEY} //= {};

        foreach my $key (keys %{$attrs}) {
            $graph -> {$type} -> {$value} -> {$ATTR_KEY} -> {$key} = $attrs -> {$key};
        }

        return 1;
    }

    sub _add_bulk {
        my ($graph, $types, $entrypoint, $threads, $keep) = @_;
        my ($from, $to) = @{$types};
        my @from_values = keys %{$graph -> {$from} // {}};
        my $queue       = Thread::Queue -> new();
        my @pairs       :shared;
        my @results;

        $queue -> enqueue(@from_values);
        $queue -> end();

        my @workers;

        for (1 .. $threads) {
            push @workers, async {
                while (defined(my $from_value = $queue -> dequeue())) {
                    my @to_values = Spellbook::Core::Module -> new($entrypoint, ['--target' => $from_value]);

                    lock(@pairs);

                    foreach my $item (@to_values) {
                        my ($to_value, $edge_attrs) = _coerce($item);
                        my $meta = $edge_attrs ? encode_json($edge_attrs) : q{};
                        push @pairs, "$from_value\0$to_value\0$meta";
                    }
                }
            };
        }

        foreach my $thread (@workers) {
            $thread -> join();
        }

        foreach my $pair (@pairs) {
            my ($from_value, $to_value, $meta) = split /\0/msx, $pair, $PAIR_FIELDS;
            my $edge_attrs = (defined $meta && $meta ne q{}) ? decode_json($meta) : undef;

            if ($from_value ne $to_value) {
                _edge($graph, [$from, $from_value], [$to, $to_value], $edge_attrs);
            }

            if ($from_value eq $to_value) {
                $graph -> {$to} -> {$to_value} //= {};
            }

            push @results, $to_value;
        }

        if (!$keep && @results) {
            _prune_type($graph, $to, \@results);
        }

        return @results;
    }

    sub _add_pairs {
        my ($graph, $types, $entrypoint, $keep) = @_;
        my ($from, $to) = @{$types};
        my @from_values = keys %{$graph -> {$from} // {}};

        if (!@from_values) {
            return ();
        }

        my @args;

        foreach my $value (@from_values) {
            push @args, '--target', $value;
        }

        my @pairs = Spellbook::Core::Module -> new($entrypoint, \@args);
        my %resolved;

        foreach my $pair (@pairs) {
            my $index = rindex $pair, q{:};

            next if $index < 0;

            my $pair_from = substr $pair, 0, $index;
            my $pair_to   = substr $pair, $index + 1;

            next if !exists $graph -> {$from} -> {$pair_from};

            push @{$resolved{$pair_from}}, $pair_to;
        }

        my @results;

        foreach my $from_value (keys %resolved) {
            foreach my $to_value (@{$resolved{$from_value}}) {
                _edge($graph, [$from, $from_value], [$to, $to_value], undef);
                push @results, "$from_value:$to_value";
            }
        }

        if (!$keep && keys %resolved) {
            foreach my $from_value (@from_values) {
                _reset_source($graph, $from, $from_value, $to, $resolved{$from_value} // []);
            }

            _prune_orphans($graph, $to);
        }

        return @results;
    }

    sub _prune_orphans {
        my ($graph, $type) = @_;

        foreach my $value (keys %{$graph -> {$type} // {}}) {
            my $node     = $graph -> {$type} -> {$value};
            my $has_edge = 0;

            foreach my $edge_type (keys %{$node}) {
                next if index($edge_type, $SIGIL) == 0;

                if (@{$node -> {$edge_type}}) {
                    $has_edge = 1;
                    last;
                }
            }

            if (!$has_edge) {
                delete $graph -> {$type} -> {$value};
            }
        }

        return 1;
    }

    sub _prune_type {
        my ($graph, $to, $fresh) = @_;
        my %keep = map { $_ => 1 } @{$fresh};

        foreach my $value (keys %{$graph -> {$to} // {}}) {
            next if $keep{$value};
            _drop_node($graph, $to, $value);
        }

        return 1;
    }

    sub _drop_node {
        my ($graph, $type, $value) = @_;
        my $node = delete $graph -> {$type} -> {$value};

        if (!$node) {
            return 1;
        }

        foreach my $edge_type (keys %{$node}) {
            next if index($edge_type, $SIGIL) == 0;

            foreach my $neighbor (@{$node -> {$edge_type}}) {
                my $peer = $graph -> {$edge_type} -> {$neighbor};

                next if !$peer;

                if ($peer -> {$type}) {
                    @{$peer -> {$type}} = grep { $_ ne $value } @{$peer -> {$type}};
                }

                if ($peer -> {$EDGE_KEY} && $peer -> {$EDGE_KEY} -> {$type}) {
                    delete $peer -> {$EDGE_KEY} -> {$type} -> {$value};
                }
            }
        }

        return 1;
    }

    sub _classify {
        my ($graph, $from, $entrypoint, $threads, $options) = @_;
        my $target = $options -> {target};
        my $key    = $options -> {key};
        my $value  = $options -> {value};

        my @nodes = $target ? ($target) : keys %{$graph -> {$from} // {}};
        my $queue = Thread::Queue -> new();
        my @matched :shared;

        $queue -> enqueue(@nodes);
        $queue -> end();

        my @workers;

        for (1 .. $threads) {
            push @workers, async {
                while (defined(my $node = $queue -> dequeue())) {
                    my @result = Spellbook::Core::Module -> new($entrypoint, ['--target' => $node]);
                    my $hit    = grep { $_ eq $node } @result;

                    if ($hit) {
                        lock @matched;
                        push @matched, $node;
                    }
                }
            };
        }

        foreach my $thread (@workers) {
            $thread -> join();
        }

        my @results;

        foreach my $node (@matched) {
            _node_attr($graph, $from, $node, { $key => $value });
            push @results, $node;
        }

        return @results;
    }

    sub _query_where {
        my ($scope, $from, $key, $value) = @_;
        my $graph = _load($scope);
        my @results;

        foreach my $node (keys %{$graph -> {$from} // {}}) {
            my $attrs = $graph -> {$from} -> {$node} -> {$ATTR_KEY} // {};

            if (defined $attrs -> {$key} && $attrs -> {$key} eq $value) {
                push @results, $node;
            }
        }

        return @results;
    }

    sub _query {
        my ($scope, $from, $to, $target) = @_;
        my $graph   = _load($scope);
        my @results;

        if ($from && !$target) {
            @results = keys %{$graph -> {$from} // {}};
        }

        if ($from && $target) {
            my $node = $graph -> {$from} -> {$target} // {};

            if ($to) {
                @results = @{$node -> {$to} // []};
            }

            if (!$to) {
                foreach my $type (keys %{$node}) {
                    next if index($type, $SIGIL) == 0;
                    push @results, @{$node -> {$type}};
                }
            }
        }

        return @results;
    }

    sub _query_attr {
        my ($scope, $from, $target, $to, $value) = @_;
        my $graph = _load($scope);
        my $node  = $graph -> {$from} -> {$target} // {};

        if ($to && $value) {
            return (encode_json($node -> {$EDGE_KEY} -> {$to} -> {$value} // {}));
        }

        if ($to) {
            return (encode_json($node -> {$EDGE_KEY} -> {$to} // {}));
        }

        return (encode_json($node -> {$ATTR_KEY} // {}));
    }

    sub _edge {
        my ($graph, $source, $sink, $attrs) = @_;
        my ($from, $from_value) = @{$source};
        my ($to, $to_value)     = @{$sink};

        $graph -> {$from} -> {$from_value} -> {$to}   //= [];
        $graph -> {$to}   -> {$to_value}   -> {$from} //= [];

        my %from_seen = map { $_ => 1 } @{$graph -> {$from} -> {$from_value} -> {$to}};
        my %to_seen   = map { $_ => 1 } @{$graph -> {$to}   -> {$to_value}   -> {$from}};

        if (!$from_seen{$to_value}) {
            push @{$graph -> {$from} -> {$from_value} -> {$to}}, $to_value;
        }

        if (!$to_seen{$from_value}) {
            push @{$graph -> {$to} -> {$to_value} -> {$from}}, $from_value;
        }

        if ($attrs && ref $attrs eq 'HASH') {
            $graph -> {$from} -> {$from_value} -> {$EDGE_KEY} -> {$to}   -> {$to_value}   = $attrs;
            $graph -> {$to}   -> {$to_value}   -> {$EDGE_KEY} -> {$from} -> {$from_value} = $attrs;
        }

        return 1;
    }

    sub _load {
        my ($scope) = @_;

        if (!-e $scope || -z $scope) {
            return {};
        }

        return decode_json(Mojo::File -> new($scope) -> slurp());
    }

    sub _save {
        my ($scope, $graph) = @_;
        Mojo::File -> new($scope) -> spew(encode_json($graph));
        return 1;
    }
}

1;
