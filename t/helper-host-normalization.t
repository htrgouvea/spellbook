#!/usr/bin/env perl

# Spellbook::Helper::Host_Normalization reduces a URL or hostname to a
# bare, lower-cased host: it adds a missing scheme, drops any path, and
# strips a leading "www." or "*." prefix.

use strict;
use warnings;

use Test::More;
use Getopt::Long ();
use FindBin;
use lib "$FindBin::RealBin/../lib";

BEGIN {
    unless ( eval { require URI::URL; 1 } ) {
        plan skip_all => 'URI::URL (URI distribution) is not installed';
    }
}

require Spellbook::Helper::Host_Normalization;

my %cases = (
    'example.com'                      => 'example.com',
    'http://example.com'               => 'example.com',
    'https://example.com/some/path?a=1' => 'example.com',
    'https://www.example.com'          => 'example.com',
    'http://WWW.EXAMPLE.COM'           => 'example.com',
    'www.test.example.org'             => 'test.example.org',
);

for my $input ( sort keys %cases ) {
    my $expected = $cases{$input};
    my $got = Spellbook::Helper::Host_Normalization->new( [ '--target' => $input ] );
    is( $got, $expected, "normalizes '$input' to '$expected'" );
}

# The help branch returns usage text.
my $help = Spellbook::Helper::Host_Normalization->new( ['--help'] );
like( $help, qr/Host_Normalization/, 'help output names the module' );

# With no recognised arguments the module returns 0.
my $empty = Spellbook::Helper::Host_Normalization->new( [] );
is( $empty, 0, 'no arguments returns 0' );

done_testing();
