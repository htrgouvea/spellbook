package Spellbook::Core::Hostname {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    ## no critic (ControlStructures::ProhibitPostfixControls, ControlStructures::ProhibitCStyleForLoops, ValuesAndExpressions::ProhibitEmptyQuotes, ValuesAndExpressions::ProhibitNoisyQuotes, ValuesAndExpressions::ProhibitMagicNumbers, References::ProhibitDoubleSigils, BuiltinFunctions::ProhibitStringySplit, RegularExpressions::RequireExtendedFormatting, RegularExpressions::RequireDotMatchAnything, RegularExpressions::RequireLineBoundaryMatching, RegularExpressions::ProhibitEnumeratedClasses, RegularExpressions::ProhibitEscapedMetacharacters, CodeLayout::ProhibitParensWithBuiltins, BuiltinFunctions::ProhibitUselessTopic, NamingConventions::ProhibitAmbiguousNames)

    sub extract_subdomain {
        my ($host, $target) = @_;
        return '' if $host eq $target;
        if ($host =~ /\.\Q$target\E$/) {
            return substr($host, 0, length($host) - length($target) - 1);
        }
        my @l = split /\./, $host;
        return '' if @l <= 2;
        return join('.', @l[0 .. $#l - 2]);
    }

    sub tokenize {
        my ($items, $target) = @_;
        my @ret;
        for my $item (@$items) {
            my $sub = extract_subdomain($item, $target);
            my @labels = split /\./, $sub, -1;
            my @n;
            for my $part (@labels) {
                my @t;
                my @parts = split /-/, $part, -1;
                my @tokens;
                for my $idx (0 .. $#parts) {
                    push @tokens, ($idx != 0 ? '-' . $parts[$idx] : $parts[$idx]);
                }
                for my $token (@tokens) {
                    my @subtokens = grep { length $_ } split /([0-9]+)/, $token, -1;
                    for (my $k = 0; $k <= $#subtokens; $k++) {
                        if ($subtokens[$k] eq '-' && $k + 1 <= $#subtokens) {
                            $subtokens[$k+1] = '-' . $subtokens[$k+1];
                        } else {
                            push @t, $subtokens[$k];
                        }
                    }
                }
                push @n, \@t;
            }
            push @ret, \@n;
        }
        return \@ret;
    }

    sub first_token {
        my ($item, $target) = @_;
        my $t = tokenize([$item], $target);
        return (defined $t->[0][0] && @{$t->[0][0]}) ? $t->[0][0][0] : '';
    }
}

1;
