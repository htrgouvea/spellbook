#!/usr/bin/env perl

# Spellbook::Helper::Uniq returns the value passed through --target.

use strict;
use warnings;

use Test::More;
use Getopt::Long ();
use FindBin;
use lib "$FindBin::RealBin/../lib";

BEGIN {
    unless ( eval { require List::MoreUtils; 1 } ) {
        plan skip_all => 'List::MoreUtils is not installed';
    }
}

require Spellbook::Helper::Uniq;

my @result = Spellbook::Helper::Uniq->new( [ '--target' => 'spellbook' ] );
is( scalar @result, 1,           'a single target yields a single value' );
is( $result[0],     'spellbook', 'the target value is returned unchanged' );

# The help branch returns usage text.
my $help = Spellbook::Helper::Uniq->new( ['--help'] );
like( $help, qr/Uniq/, 'help output names the module' );

# With no recognised arguments the module returns 0.
my $empty = Spellbook::Helper::Uniq->new( [] );
is( $empty, 0, 'no arguments returns 0' );

done_testing();
