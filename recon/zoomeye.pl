#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;

sub main {
    my $query = $ARGV[0];

    if ($query) {
        my $endpoint  = "https://api.zoomeye.org/host/search?query=$query";
        my $userAgent = LWP::UserAgent -> new();
        my $request   = $userAgent -> get($endpoint,
            "Authorization" => "JWT $zoomToken"
        );

        if ($request -> code() == "200") {
            my $data = $request -> content();
            print $data;
        }
    }   
}

main();
exit;
