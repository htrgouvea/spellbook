#!/usr/bin/env perl

# Spellbook::Core::UserAgent builds a pre-configured LWP::UserAgent.

use strict;
use warnings;

use Readonly;
use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

our $VERSION = '0.0.1';

# The module hard-codes these in its constructor; the test pins them so a
# silent change to the timeout or the identifying User-Agent is caught.
Readonly my $EXPECTED_TIMEOUT => 5;
Readonly my $EXPECTED_AGENT   => 'Spellbook / v0.3.8';

BEGIN {
    if ( !eval { require LWP::UserAgent; 1 } ) {
        plan skip_all => 'LWP::UserAgent is not installed';
    }
}

require Spellbook::Core::UserAgent;

my $agent = Spellbook::Core::UserAgent->new();

isa_ok( $agent, 'LWP::UserAgent', 'new() returns an LWP::UserAgent' );
is( $agent->timeout, $EXPECTED_TIMEOUT, 'the request timeout is 5 seconds' );
is( $agent->agent, $EXPECTED_AGENT, 'the User-Agent string identifies Spellbook' );
is(
    $agent->default_headers->header('Cache-Control'),
    'no-cache',
    'a no-cache Cache-Control header is set by default'
);

done_testing();
