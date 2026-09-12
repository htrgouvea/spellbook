package Spellbook::Core::Distance {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    ## no critic (ControlStructures::ProhibitPostfixControls, ValuesAndExpressions::ProhibitEmptyQuotes, ValuesAndExpressions::ProhibitEscapedCharacters, References::ProhibitDoubleSigils, ValuesAndExpressions::ProhibitMagicNumbers, BuiltinFunctions::ProhibitStringySplit, RegularExpressions::RequireExtendedFormatting, RegularExpressions::RequireDotMatchAnything, RegularExpressions::RequireLineBoundaryMatching, CodeLayout::ProhibitParensWithBuiltins, NamingConventions::ProhibitAmbiguousNames)

    my %DIST;

    sub levenshtein {
        my ($s, $t) = @_;
        return length($t) if $s eq '';
        return length($s) if $t eq '';
        my @s = split //, $s;
        my @t = split //, $t;
        my @prev = (0 .. scalar @t);
        for my $i (1 .. scalar @s) {
            my @cur = ($i);
            for my $j (1 .. scalar @t) {
                my $cost = ($s[$i-1] eq $t[$j-1]) ? 0 : 1;
                my $del = $prev[$j] + 1;
                my $ins = $cur[$j-1] + 1;
                my $sub = $prev[$j-1] + $cost;
                my $m = $del < $ins ? $del : $ins;
                $m = $sub if $sub < $m;
                push @cur, $m;
            }
            @prev = @cur;
        }
        return $prev[-1];
    }

    sub distance {
        my ($a, $b) = @_;
        my $k = $a le $b ? "$a\x00$b" : "$b\x00$a";
        return $DIST{$k} //= levenshtein($a, $b);
    }

    sub edit_closures {
        my ($items, $delta) = @_;
        my (@ret, %seen);
        for my $a (@$items) {
            my %r = ($a => 1);
            for my $b (@$items) {
                $r{$b} = 1 if distance($a, $b) < $delta;
            }
            my $key = join("\x00", sort keys %r);
            next if $seen{$key}++;
            push @ret, [sort keys %r];
        }
        return \@ret;
    }
}

1;
