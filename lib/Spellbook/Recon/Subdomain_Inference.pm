package Spellbook::Recon::Subdomain_Inference {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Core::Distance;
    use Spellbook::Core::Hostname;
    use Spellbook::Core::Regular_Language;

    our $VERSION = '0.0.2';

    ## no critic (ControlStructures::ProhibitPostfixControls, ControlStructures::ProhibitCStyleForLoops, ControlStructures::ProhibitCascadingIfElse, ValuesAndExpressions::ProhibitMagicNumbers, ValuesAndExpressions::ProhibitEmptyQuotes, ValuesAndExpressions::ProhibitNoisyQuotes, ValuesAndExpressions::ProhibitEscapedCharacters, ValuesAndExpressions::ProhibitInterpolationOfLiterals, RegularExpressions::RequireExtendedFormatting, RegularExpressions::RequireDotMatchAnything, RegularExpressions::RequireLineBoundaryMatching, RegularExpressions::ProhibitEnumeratedClasses, RegularExpressions::ProhibitEscapedMetacharacters, BuiltinFunctions::ProhibitStringySplit, BuiltinFunctions::ProhibitUselessTopic, BuiltinFunctions::ProhibitReverseSortBlock, Subroutines::ProhibitExcessComplexity, Subroutines::RequireFinalReturn, ControlStructures::ProhibitDeepNests, ControlStructures::ProhibitNegativeExpressionsInUnlessAndUntilConditions, CodeLayout::ProhibitParensWithBuiltins, References::ProhibitDoubleSigils, NamingConventions::ProhibitAmbiguousNames, InputOutput::RequireCheckedClose)

    my $DNS_CHARS = join('', 'a'..'z') . join('', 0..9) . '._-';

    my ($TARGET, $THRESHOLD, $MAX_RATIO, $MAX_LENGTH, $DL, $DH);
    my (%new_rules);

    # ---- closure_to_regex: edit closure -> regular expression -----------------
    sub closure_to_regex {
        my ($domain, $members) = @_;
        my $tokens = Spellbook::Core::Hostname::tokenize($members, $TARGET);
        my (@levels, @optional);
        for my $member (@$tokens) {
            for my $i (0 .. $#$member) {
                my $level = $member->[$i];
                $levels[$i]   //= {};
                $optional[$i] //= [];
                for my $j (0 .. $#$level) {
                    my $tok = $level->[$j];
                    $levels[$i]{$j}   //= {};
                    $optional[$i][$j] //= [];
                    $levels[$i]{$j}{$tok} = 1;
                    push @{$optional[$i][$j]}, $tok;
                }
            }
        }
        my $nmembers = scalar @$tokens;
        my $ret = '';
        for my $i (0 .. $#levels) {
            my $n = $i != 0 ? '(.' : '';
            my @positions = sort { $a <=> $b } keys %{$levels[$i]};
            for my $j (@positions) {
                my @toks = sort keys %{$levels[$i]{$j}};
                my $k = scalar @toks;
                if ($i == 0 && $j == 0) {
                    $n .= '(' . join('|', @toks) . ')';
                } elsif ($k == 1 && $j == 0) {
                    $n .= join('|', @toks);
                } else {
                    my $isopt = scalar(@{$optional[$i][$j]}) != $nmembers;
                    $n .= '(' . join('|', @toks) . ')' . ($isopt ? '?' : '');
                }
            }
            my @lists = map { $optional[$i][$_] } (0 .. $#{$optional[$i]});
            my $min;
            for (@lists) { my $l = scalar @$_; $min = $l if !defined $min || $l < $min; }
            $min //= 0;
            my @values;
            for my $kk (0 .. $min - 1) {
                push @values, join('', map { $_->[$kk] } @lists);
            }
            my %u; $u{$_} = 1 for @values;
            my $isopt = (scalar(keys %u) != 1) || (scalar(@values) != $nmembers);
            if ($i != 0) { $ret .= $isopt ? $n . ")?" : $n . ")"; }
            else         { $ret .= $n; }
        }
        return compress_number_ranges("$ret.$domain");
    }

    # ---- compress_number_ranges: (foo1|foo2|foo5) -> foo[1-5] ------------------
    sub compress_number_ranges {
        my ($regex) = @_;
        my $ret = $regex;
        my (@stack, @groups, %repl, %extra, %hyphen);
        my @chars = split //, $regex;
        for my $i (0 .. $#chars) {
            my $e = $chars[$i];
            if ($e eq '(') {
                push @stack, $i;
            } elsif ($e eq ')') {
                next unless @stack;
                my $start = pop @stack;
                my $group = substr($regex, $start + 1, $i - $start - 1);
                my @tokens = split /\|/, $group, -1;
                my @numbers    = grep { /^[0-9]+$/ } @tokens;
                my @nonnumbers = grep { !/^[0-9]+$/ && !/^-[0-9]+/ } @tokens;
                my @hyph       = map  { substr($_, 1) } grep { /^-[0-9]+/ } @tokens;
                next if $group =~ /[?()]/;
                if (@numbers && @hyph) { next; }
                elsif (@numbers > 1) {
                    my $g1 = join('|', @numbers);
                    $repl{$g1} = $group; $extra{$g1} = join('|', @nonnumbers);
                    push @groups, $g1;
                } elsif (@hyph > 1) {
                    my $g1 = join('|', @hyph);
                    $repl{$g1} = $group; $extra{$g1} = join('|', @nonnumbers);
                    push @groups, $g1; $hyphen{$g1} = 1;
                }
            }
        }
        for my $group (@groups) {
            my $generalized = exists $hyphen{$group} ? '(-' : '(';
            my %positions;
            my @toks = map { scalar reverse $_ } split /\|/, $group;
            for my $token (@toks) {
                my @d = split //, $token;
                for my $pos (0 .. $#d) { $positions{$pos}{$d[$pos]} = 1; }
            }
            my @s = sort { length($a) <=> length($b) } @toks;
            my $lstart = length($s[-1]) - 1;
            my $lend   = length($s[0]) - 1;
            for (my $ii = $lstart; $ii > $lend; $ii--) { $positions{$ii}{'None'} = 1; }
            for my $ii (sort { $b <=> $a } keys %positions) {
                my $optional = exists $positions{$ii}{'None'};
                delete $positions{$ii}{'None'} if $optional;
                my @syms = sort { $a <=> $b } keys %{$positions{$ii}};
                my ($st, $en) = ($syms[0], $syms[-1]);
                if ($st != $en) { $generalized .= "[$st-$en]" . ($optional ? '?' : ''); }
                else            { $generalized .= "$st"       . ($optional ? '?' : ''); }
            }
            $generalized .= ')';
            my $ext = $extra{$group};
            my $rep = $repl{$group};
            if (defined $ext && $ext ne '') { $generalized = "($generalized|($ext))"; }
            my $q = quotemeta("($rep)");
            $ret =~ s/$q/$generalized/g;
        }
        return $ret;
    }

    sub try_rule {
        my ($r, $nkeys) = @_;
        return if $new_rules{$r};
        $new_rules{$r} = 1 if Spellbook::Core::Regular_Language::is_good_rule($r, $nkeys, $THRESHOLD, $MAX_RATIO);
    }

    # ---- entrypoint -----------------------------------------------------------
    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $hosts);

        $THRESHOLD  = 500;
        $MAX_RATIO  = 25.0;
        $MAX_LENGTH = 1000;
        $DL         = 2;
        $DH         = 10;
        %new_rules  = ();

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'f|hosts=s'    => \$hosts,
            'threshold=i'  => \$THRESHOLD,
            'max-ratio=f'  => \$MAX_RATIO,
            'max-length=i' => \$MAX_LENGTH,
            'dist-low=i'   => \$DL,
            'dist-high=i'  => \$DH,
        );

        if ($target && $hosts) {
            $TARGET = $target;

            open(my $fh, '<', $hosts) or return 0;
            my (%seen_host, @known_hosts);
            while (my $line = <$fh>) {
                $line =~ s/\s+$//; $line =~ s/^\s+//;
                next if $line eq '';
                next if $seen_host{$line}++;
                push @known_hosts, $line;
            }
            close $fh;
            @known_hosts = sort @known_hosts;

            my @valid;
            for my $host (@known_hosts) {
                next if $host eq $TARGET;
                my $tk = Spellbook::Core::Hostname::tokenize([$host], $TARGET);
                if (@$tk && @{$tk->[0]} && @{$tk->[0][0]}) {
                    push @valid, $host;
                }
            }

            for my $k ($DL .. $DH - 1) {
                my $closures = Spellbook::Core::Distance::edit_closures(\@known_hosts, $k);
                for my $c (@$closures) {
                    next unless @$c > 1;
                    my $r = closure_to_regex($TARGET, $c);
                    next if length($r) > $MAX_LENGTH;
                    try_rule($r, scalar @$c);
                }
            }

            my @dnschars = split //, $DNS_CHARS;
            my %ng; $ng{$_} = 1 for @dnschars;
            for my $x (@dnschars) { for my $y (@dnschars) { $ng{"$x$y"} = 1; } }
            my @ngrams = sort keys %ng;

            for my $ngram (@ngrams) {
                my @keys = grep { index($_, $ngram) == 0 } @valid;
                next unless @keys;

                my $r = closure_to_regex($TARGET, \@keys);
                try_rule($r, scalar @keys);

                my %pf;
                for my $kk (@keys) {
                    my $ft = Spellbook::Core::Hostname::first_token($kk, $TARGET);
                    $pf{$ft} = 1 if length $ft;
                }
                my @prefixes = sort keys %pf;
                my $last;

                for my $prefix (@prefixes) {
                    my @keys2 = grep { index($_, $prefix) == 0 } @valid;

                    my $r2 = closure_to_regex($TARGET, \@keys2);
                    if (!$new_rules{$r2} && Spellbook::Core::Regular_Language::is_good_rule($r2, scalar @keys2, $THRESHOLD, $MAX_RATIO)) {
                        if (!defined $last || index($prefix, $last) != 0) {
                            $last = $prefix;
                            $new_rules{$r2} = 1;
                        } else {
                            next;
                        }
                    }

                    if (length($prefix) > 1) {
                        for my $k ($DL .. $DH - 1) {
                            my $closures = Spellbook::Core::Distance::edit_closures(\@keys2, $k);
                            for my $c (@$closures) {
                                my $r3 = closure_to_regex($TARGET, $c);
                                try_rule($r3, scalar @$c);
                            }
                        }
                    }
                }
            }

            my %candidates;
            for my $rule (keys %new_rules) {
                for my $w (Spellbook::Core::Regular_Language::generate($rule)) {
                    $w =~ s/\.{2,}/./g;
                    $candidates{$w} = 1;
                }
            }

            my @found = sort keys %candidates;
            return @found;
        }

        if ($help) {
            return "\n"
                . "Recon::Subdomain_Inference\n"
                . "=====================\n"
                . "-h, --help        See this menu\n"
                . "-t, --target      Target domain (required)\n"
                . "-f, --hosts       File of observed hosts, one per line (required)\n"
                . "    --threshold   Ratio-test threshold (default 500)\n"
                . "    --max-ratio   Ratio-test R (default 25.0)\n"
                . "    --max-length  Max rule length in the global phase (default 1000)\n"
                . "    --dist-low    Lower Levenshtein bound (default 2)\n"
                . "    --dist-high   Upper Levenshtein bound (default 10)\n\n";
        }

        return 0;
    }
}

1;
