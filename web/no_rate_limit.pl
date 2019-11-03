#!/usr/bin/env perl

# draft code

use JSON;
use 5.010;
use strict;
use warnings;
use LWP::UserAgent;

sub main {
    my $endpoint = "";

    my $userAgent = LWP::UserAgent -> new();

    my $header = [
        "Accept" => "application/json; charset=UTF-8",
        "Content-Type" => "application/json",
        "Accept-Encoding" => "gzip, deflate",
    ];

    my $datas = '';

    for (my $i = 0; $i <= 650; $i++) {
        my $request  = new HTTP::Request("POST", $endpoint, $header);
        my $response = $userAgent -> request($request);
        my $httpCode = $response -> code();
        
        print "[ ! ] -> Send request => [ $i ]\n";
    }

}

main();
exit;