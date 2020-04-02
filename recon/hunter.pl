#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use Data::Dumper;

sub main {
    my $domain = $ARGV[0];

    if ($domain) {
        my $apiKey    = "";
        my $endpoint  = "https://api.hunter.io/v2/domain-search?domain=$domain&api_key=$apiKey";
        my $userAgent = LWP::UserAgent -> new();
	    my $request   = $userAgent -> get($endpoint);
	    my $httpCode  = $request -> code();

        if ($httpCode == 200) {
            my $content = decode_json($request -> content);

            foreach my $email (@{$content -> {'data'} -> {'emails'}}) {
                print $email -> {'value'}, "\n";
            }
        }
    }   

}

main();
exit;