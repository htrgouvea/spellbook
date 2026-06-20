#!/usr/bin/env perl

# Spellbook::Core::UserAgent builds a pre-configured LWP::UserAgent.

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

BEGIN {
    unless ( eval { require LWP::UserAgent; 1 } ) {
        plan skip_all => 'LWP::UserAgent is not installed';
    }
}

require Spellbook::Core::UserAgent;

my $agent = Spellbook::Core::UserAgent->new();

isa_ok( $agent, 'LWP::UserAgent', 'new() returns an LWP::UserAgent' );
is( $agent->timeout, 5, 'the request timeout is 5 seconds' );
is( $agent->agent, 'Spellbook / v0.3.8', 'the User-Agent string identifies Spellbook' );
is(
    $agent->default_headers->header('Cache-Control'),
    'no-cache',
    'a no-cache Cache-Control header is set by default'
);

done_testing();
