#!/usr/bin/env perl

# Spellbook::Core::Module is the dispatcher: it resolves a "Category::Module"
# name against the catalogue, loads it, runs it, and collects its output.

use strict;
use warnings;

use Test::More;
use Getopt::Long ();
use FindBin;
use lib "$FindBin::RealBin/../lib";

# The dispatcher relies on Resources, which reads .config/modules.json
# relative to the current directory.
chdir "$FindBin::RealBin/.." or die "Unable to chdir to repository root: $!";

BEGIN {
    unless ( eval { require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Mojolicious (Mojo::File / Mojo::JSON) is not installed';
    }
}

require Spellbook::Core::Module;

# An unknown module name yields a "not found" message rather than dying.
my @missing = Spellbook::Core::Module->new( 'Does::NotExist', [] );
like( join( q{}, @missing ), qr/Module not found/, 'unknown modules report "not found"' );

# A known, dependency-free module is loaded and executed end to end.
# Helper::Permutations rearranges the characters of the given value, so the
# dispatched result must be a permutation of the input.
my @run = Spellbook::Core::Module->new( 'Helper::Permutations', [ '--value' => 'abc' ] );
is( scalar @run, 1, 'the dispatched module returns a single result' );
is( join( q{}, sort split //, $run[0] ), 'abc', 'the dispatched result is a permutation of the input' );

done_testing();
