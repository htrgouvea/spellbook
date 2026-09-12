package Spellbook::Recon::Certificate_Monitor {
    use strict;
    use warnings;
    use Getopt::Long;
    use Mojo::File;
    use Mojo::JSON qw(decode_json encode_json);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK       => 200;
    Readonly my $HTTP_TIMEOUT  => 60;
    Readonly my $DEFAULT_STATE => '.config/certificate_monitor.json';

    sub _load_state {
        my ($state_path) = @_;

        my $file = Mojo::File -> new($state_path);

        if (!-r $file) {
            return {};
        }

        my $state = eval { decode_json($file -> slurp()) };

        if (ref $state ne 'HASH') {
            return {};
        }

        return $state;
    }

    sub _save_state {
        my ($state_path, $state) = @_;

        my $file = Mojo::File -> new($state_path);

        $file -> dirname() -> make_path();
        $file -> spurt(encode_json($state));

        return;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $state_path, $start_at_end, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'         => \$help,
            't|target=s'     => \$target,
            's|state=s'      => \$state_path,
            'e|start-at-end' => \$start_at_end
        );

        if ($target) {
            if ($target =~ /\Ahttp(?:s)?:\/\//msx) {
                $target =~ s/\Ahttp(?:s)?:\/\///msx;
            }

            $target =~ s{/.*\z}{}msx;
            $target = lc $target;

            if (!$state_path) {
                $state_path = $DEFAULT_STATE;
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();

            $user_agent -> timeout($HTTP_TIMEOUT);

            my $endpoint = "https://crt.sh/?q=%25.$target&output=json";
            my $request  = $user_agent -> get($endpoint);

            if ($request -> code() != $HTTP_OK) {
                return @result;
            }

            my $content = eval { decode_json($request -> content()) };

            if (ref $content ne 'ARRAY') {
                return @result;
            }

            my $state   = _load_state($state_path);
            my $last_id = $state -> {$target} -> {last_id} // 0;
            my $max_id  = $last_id;

            my @fresh;

            foreach my $entry (@{$content}) {
                my $id = $entry -> {id};

                if (!defined $id) {
                    next;
                }

                if ($id > $max_id) {
                    $max_id = $id;
                }

                if ($id <= $last_id) {
                    next;
                }

                my @names = _match_names($entry -> {name_value}, $target);

                if (!scalar @names) {
                    next;
                }

                push @fresh, {
                    id         => $id,
                    names      => [@names],
                    issuer     => $entry -> {issuer_name},
                    not_before => $entry -> {not_before},
                    not_after  => $entry -> {not_after}
                };
            }

            if ($start_at_end && ($last_id == 0)) {
                @fresh = ();
            }

            $state -> {$target} -> {last_id} = $max_id;
            _save_state($state_path, $state);

            foreach my $cert (sort { $a -> {id} <=> $b -> {id} } @fresh) {
                push @result, encode_json($cert);
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Certificate_Monitor\n"
                . "==========================\n"
                . "-h, --help          See this menu\n"
                . "-t, --target        Domain to monitor in the CT logs (via crt.sh)\n"
                . "-s, --state         State file path (default: $DEFAULT_STATE)\n"
                . "-e, --start-at-end  On the first run, only record the baseline (report nothing)\n\n";
        }

        return 0;
    }

    sub _match_names {
        my ($names, $target) = @_;

        my (@matched, %seen);

        if (!defined $names) {
            return @matched;
        }

        foreach my $name (split /\n/msx, $names) {
            $name = lc $name;
            $name =~ s/\A\s+//msx;
            $name =~ s/\s+\z//msx;

            my $bare = $name;
            $bare =~ s/\A[*][.]//msx;

            if ($bare !~ /\A[[:lower:][:digit:]._-]+\z/msx) {
                next;
            }

            if ($bare !~ /[.]\Q$target\E\z|\A\Q$target\E\z/msx) {
                next;
            }

            if ($seen{$name}) {
                next;
            }

            $seen{$name} = 1;
            push @matched, $name;
        }

        return @matched;
    }
}

1;
