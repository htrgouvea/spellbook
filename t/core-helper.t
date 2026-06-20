#!/usr/bin/env perl

# Spellbook::Core::Helper prints the top-level help banner and returns 1.

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

require Spellbook::Core::Helper;

# Capture STDOUT so the banner does not pollute the test output.
my $output = q{};
my $return;
{
    open my $capture, '>', \$output or die "Cannot open in-memory handle: $!";
    my $previous = select $capture;
    $return = Spellbook::Core::Helper->new();
    select $previous;
    close $capture;
}

is( $return, 1, 'new() returns 1' );
like( $output, qr/Spellbook/,   'banner mentions Spellbook' );
like( $output, qr/--search/,    'banner documents the --search flag' );
like( $output, qr/--module/,    'banner documents the --module flag' );

done_testing();
