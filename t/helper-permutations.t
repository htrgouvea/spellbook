#!/usr/bin/env perl

# Spellbook::Helper::Permutations shuffles the characters of a value.
# A shuffle must preserve both the length and the exact multiset of
# characters of the input, and --repeat controls how many shuffles are
# produced.

use strict;
use warnings;

use Test::More;
use Getopt::Long ();
use FindBin;
use lib "$FindBin::RealBin/../lib";

require Spellbook::Helper::Permutations;

sub sorted_chars {
    my ($string) = @_;
    return join q{}, sort split //, $string;
}

# Default behaviour: a single permutation of the value.
my @single = Spellbook::Helper::Permutations->new( [ '--value' => 'abcde' ] );
is( scalar @single, 1, 'one permutation is returned by default' );
is( length $single[0], 5, 'the permutation keeps the original length' );
is( sorted_chars( $single[0] ), 'abcde', 'the permutation keeps every character' );

# --repeat produces the requested number of permutations.
my @many = Spellbook::Helper::Permutations->new( [ '--value' => 'xyz', '--repeat' => 4 ] );
is( scalar @many, 4, '--repeat 4 returns four permutations' );
for my $permutation (@many) {
    is( sorted_chars($permutation), 'xyz', "permutation '$permutation' is a rearrangement of xyz" );
}

# The help branch returns usage text.
my $help = Spellbook::Helper::Permutations->new( ['--help'] );
like( $help, qr/Permutations/, 'help output names the module' );

# With no recognised arguments the module returns 0.
my $empty = Spellbook::Helper::Permutations->new( [] );
is( $empty, 0, 'no arguments returns 0' );

done_testing();
