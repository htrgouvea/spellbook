#!/usr/bin/env perl

# Spellbook::Core::Helper prints the top-level help banner and returns 1.

use strict;
use warnings;

use Carp;
use English qw(-no_match_vars);
use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

our $VERSION = '0.0.1';

require Spellbook::Core::Helper;

# Capture STDOUT so the banner does not pollute the test output.
my $output = q{};
my $return;
{
    open my $capture, '>', \$output or croak "Cannot open in-memory handle: $OS_ERROR";

    # One-argument select is the idiom for redirecting the default output
    # handle; the module prints to STDOUT without taking a handle argument.
    my $previous = select $capture;    ## no critic (InputOutput::ProhibitOneArgSelect)
    $return = Spellbook::Core::Helper->new();
    select $previous;                  ## no critic (InputOutput::ProhibitOneArgSelect)
    close $capture or croak "Cannot close in-memory handle: $OS_ERROR";
}

is( $return, 1, 'new() returns 1' );
like( $output, qr/Spellbook/msx, 'banner mentions Spellbook' );
like( $output, qr/--search/msx,  'banner documents the --search flag' );
like( $output, qr/--module/msx,  'banner documents the --module flag' );

done_testing();
