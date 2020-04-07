#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use Data::Dumper;

sub main {
    my $ip = $ARGV[0];

    if ($ip) {
        my $apiKey    = "";
        my $endpoint  = "https://api.shodan.io/shodan/host/$ip?key=$apiKey";
        my $userAgent = LWP::UserAgent -> new();
	    my $request   = $userAgent -> get($endpoint);
	    my $httpCode  = $request -> code();

        if ($httpCode == 200) {
            my $content = decode_json($request -> content);

            print "\n$ip\n";

            foreach my $data (@{$content -> {'data'}}) {
                my $port      = $data -> {'port'};
                my $transport = $data -> {'transport'};
                my $service   = $data -> {'_shodan'} -> {'module'};

                print "[$transport] -> $port | $service\n";
            }
        }
    }   

}

main();
exit;