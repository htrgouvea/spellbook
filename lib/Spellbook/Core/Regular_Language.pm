package Spellbook::Core::Regular_Language {
    use strict;
    use warnings;
    no warnings 'recursion';  ## no critic (TestingAndDebugging::ProhibitNoWarnings)

    our $VERSION = '0.0.1';

    ## no critic (ControlStructures::ProhibitPostfixControls, ControlStructures::ProhibitCascadingIfElse, ValuesAndExpressions::ProhibitMagicNumbers, ValuesAndExpressions::ProhibitEmptyQuotes, ValuesAndExpressions::ProhibitNoisyQuotes, ValuesAndExpressions::ProhibitEscapedCharacters, RegularExpressions::RequireExtendedFormatting, RegularExpressions::RequireDotMatchAnything, RegularExpressions::RequireLineBoundaryMatching, RegularExpressions::ProhibitEscapedMetacharacters, BuiltinFunctions::ProhibitStringySplit, Subroutines::ProhibitManyArgs, Subroutines::ProhibitExcessComplexity, Subroutines::RequireFinalReturn, ControlStructures::ProhibitDeepNests, ControlStructures::ProhibitNegativeExpressionsInUnlessAndUntilConditions, CodeLayout::ProhibitParensWithBuiltins, References::ProhibitDoubleSigils, NamingConventions::ProhibitAmbiguousNames, BuiltinFunctions::ProhibitReverseSortBlock)

    my %ANALYZE;

    sub preprocess {
        my ($regex) = @_;
        while ($regex =~ /\[(.)-(.)\]/) {
            my ($a, $b) = ($1, $2);
            my $exp = '(' . join('|', map { chr } (ord($a) .. ord($b))) . ')';
            my $needle = quotemeta("[$a-$b]");
            $regex =~ s/$needle/$exp/;
        }
        return $regex;
    }

    sub _ins { my ($pool, $s, $sym, $t) = @_; $pool->[$s]{trans}{$sym}{$t} = 1; }

    sub _from_regex {
        my ($pool, $regex, $s, $t, $lo, $hi) = @_;
        my $len = $hi - $lo;
        if ($len == 1) { _ins($pool, $s, ord(substr($regex, $lo, 1)), $t); return; }
        if ($len == 2 && substr($regex, $lo, 1) eq '\\') {
            _ins($pool, $s, ord(substr($regex, $lo + 1, 1)), $t); return;
        }
        my ($option, $concat, $depth) = ($lo, $lo, 0);
        my $i = $lo;
        while ($i < $hi) {
            my $c = substr($regex, $i, 1);
            if    ($c eq '\\') { $concat = $i if $depth == 0; $i++; }
            elsif ($c eq '(')  { $concat = $i if $depth == 0; $depth++; }
            elsif ($c eq ')')  { $depth--; }
            elsif ($c eq '|')  { $option = $i if $depth == 0; }
            elsif ($c eq '?')  { }
            elsif ($c eq '*')  { }
            elsif ($c eq '+')  { }
            else               { $concat = $i if $depth == 0; }
            $i++;
        }
        if ($option != $lo) {
            my $i0 = scalar @$pool; push @$pool, _st(), _st(); my $i1 = $i0 + 1;
            _ins($pool, $s, 0, $i0); _ins($pool, $i1, 0, $t);
            _from_regex($pool, $regex, $i0, $i1, $lo, $option);
            $i0 = scalar @$pool; push @$pool, _st(), _st(); $i1 = $i0 + 1;
            _ins($pool, $s, 0, $i0); _ins($pool, $i1, 0, $t);
            _from_regex($pool, $regex, $i0, $i1, $option + 1, $hi);
        } elsif ($concat != $lo) {
            my $i0 = scalar @$pool; push @$pool, _st(), _st(); my $i1 = $i0 + 1;
            _ins($pool, $i0, 0, $i1);
            _from_regex($pool, $regex, $s, $i0, $lo, $concat);
            _from_regex($pool, $regex, $i1, $t, $concat, $hi);
        } elsif (substr($regex, $hi - 1, 1) eq '?') {
            my $i0 = scalar @$pool; push @$pool, _st(), _st(); my $i1 = $i0 + 1;
            _ins($pool, $s, 0, $i0); _ins($pool, $s, 0, $t); _ins($pool, $i1, 0, $t);
            _from_regex($pool, $regex, $i0, $i1, $lo, $hi - 1);
        } elsif (substr($regex, $hi - 1, 1) eq '*') {
            my $i0 = scalar @$pool; push @$pool, _st(), _st(); my $i1 = $i0 + 1;
            _ins($pool, $s, 0, $i0); _ins($pool, $s, 0, $t);
            _ins($pool, $i1, 0, $i0); _ins($pool, $i1, 0, $t);
            _from_regex($pool, $regex, $i0, $i1, $lo, $hi - 1);
        } elsif (substr($regex, $hi - 1, 1) eq '+') {
            my $i0 = scalar @$pool; push @$pool, _st(), _st(); my $i1 = $i0 + 1;
            _ins($pool, $i0, 0, $i1);
            _from_regex($pool, $regex, $s, $i0, $lo, $hi - 1);
            $s = $i1;
            $i0 = scalar @$pool; push @$pool, _st(), _st(); $i1 = $i0 + 1;
            _ins($pool, $s, 0, $i0); _ins($pool, $s, 0, $t);
            _ins($pool, $i1, 0, $i0); _ins($pool, $i1, 0, $t);
            _from_regex($pool, $regex, $i0, $i1, $lo, $hi - 1);
        } else {
            _from_regex($pool, $regex, $s, $t, $lo + 1, $hi - 1);
        }
    }

    sub _st { return { final => 0, trans => {} }; }

    sub nfa_from_regex {
        my ($regex) = @_;
        my @pool = ({ final => 0, trans => {} }, { final => 1, trans => {} });
        my %init = (0 => 1);
        _from_regex(\@pool, $regex, 0, 1, 0, length($regex));
        get_closure(\@pool, \%init);
        return { pool => \@pool, init => \%init };
    }

    sub get_closure {
        my ($pool, $set) = @_;
        my @q = keys %$set;
        while (@q) {
            my $u = shift @q;
            my $tr = $pool->[$u]{trans};
            next unless exists $tr->{0};
            for my $t (keys %{$tr->{0}}) {
                if (!$set->{$t}) { $set->{$t} = 1; push @q, $t; }
            }
        }
    }

    sub setkey { my ($set) = @_; return join(',', sort { $a <=> $b } keys %$set); }

    sub determinize {
        my ($nfa) = @_;
        my $pool = $nfa->{pool};
        my @dpool = ({ final => 0, trans => {} });
        my %m;
        my $init = $nfa->{init};
        $m{setkey($init)} = 0;
        for my $s (keys %$init) { if ($pool->[$s]{final}) { $dpool[0]{final} = 1; last; } }
        my @queue = ([$init, 0]);
        while (@queue) {
            my ($u0, $u1) = @{ shift @queue };
            my %moves;
            for my $s (keys %$u0) {
                my $tr = $pool->[$s]{trans};
                for my $sym (keys %$tr) {
                    next if $sym == 0;
                    for my $tgt (keys %{$tr->{$sym}}) { $moves{$sym}{$tgt} = 1; }
                }
            }
            for my $sym (sort { $a <=> $b } keys %moves) {
                my $set = $moves{$sym};
                get_closure($pool, $set);
                my $key = setkey($set);
                if (!exists $m{$key}) {
                    my $v1 = scalar @dpool;
                    push @dpool, { final => 0, trans => {} };
                    $dpool[$u1]{trans}{$sym} = $v1;
                    $m{$key} = $v1;
                    for my $s (keys %$set) { if ($pool->[$s]{final}) { $dpool[$v1]{final} = 1; last; } }
                    push @queue, [$set, $v1];
                } else {
                    $dpool[$u1]{trans}{$sym} = $m{$key};
                }
            }
        }
        return { pool => \@dpool, init => 0 };
    }

    sub dfa_reverse {
        my ($dfa) = @_;
        my $n = scalar @{ $dfa->{pool} };
        my @pool = map { { final => 0, trans => {} } } (1 .. $n);
        my %init;
        for my $i (0 .. $n - 1) {
            my $tr = $dfa->{pool}[$i]{trans};
            for my $sym (keys %$tr) {
                my $t = $tr->{$sym};
                $pool[$t]{trans}{$sym}{$i} = 1;
            }
            $init{$i} = 1 if $dfa->{pool}[$i]{final};
        }
        $pool[ $dfa->{init} ]{final} = 1;
        return { pool => \@pool, init => \%init };
    }

    sub minimize {
        my ($nfa) = @_;
        my $d1 = determinize($nfa);
        my $n1 = dfa_reverse($d1);
        my $d2 = determinize($n1);
        my $n2 = dfa_reverse($d2);
        my $d3 = determinize($n2);
        return $d3;
    }

    sub analyze {
        my ($regex) = @_;
        return $ANALYZE{$regex} if exists $ANALYZE{$regex};
        my $dfa = minimize(nfa_from_regex(preprocess($regex)));
        my $np  = scalar @{ $dfa->{pool} };
        my $maxlen = $np - 1;
        $maxlen = 256 if $maxlen > 256;
        $maxlen = 0   if $maxlen < 0;
        my @T;
        for my $q (0 .. $np - 1) { $T[$q][0] = $dfa->{pool}[$q]{final} ? 1 : 0; }
        for my $L (1 .. $maxlen) {
            for my $q (0 .. $np - 1) {
                my $sum = 0;
                my $tr = $dfa->{pool}[$q]{trans};
                $sum += $T[$_][$L-1] for values %$tr;
                $T[$q][$L] = $sum;
            }
        }
        my $total = 0;
        $total += $T[0][$_] for (1 .. $maxlen);
        my $res = { dfa => $dfa, T => \@T, maxlen => $maxlen, total => $total, fs => $np - 1 };
        $ANALYZE{$regex} = $res;
        return $res;
    }

    sub is_good_rule {
        my ($regex, $nkeys, $threshold, $max_ratio) = @_;
        my $nwords = analyze($regex)->{total};
        return 1 if $nwords < $threshold;
        return (($nwords / $nkeys) < $max_ratio) ? 1 : 0;
    }

    sub generate {
        my ($regex) = @_;
        my $an = analyze($regex);
        my $fs = $an->{fs};
        return () if $fs < 1 || $fs > $an->{maxlen};
        my $T   = $an->{T};
        my $dfa = $an->{dfa};
        my @out;
        my @buf;
        my $rec;
        $rec = sub {
            my ($q, $rem) = @_;
            if ($rem == 0) {
                push @out, join('', @buf) if $dfa->{pool}[$q]{final};
                return;
            }
            my $tr = $dfa->{pool}[$q]{trans};
            for my $sym (sort { $a <=> $b } keys %$tr) {
                my $tgt = $tr->{$sym};
                next unless $T->[$tgt][$rem - 1] > 0;
                push @buf, chr($sym);
                $rec->($tgt, $rem - 1);
                pop @buf;
            }
        };
        $rec->(0, $fs);
        return @out;
    }
}

1;
