#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use HTTP::Request;
use LWP::UserAgent;

sub main {
    my $target   = $ARGV[0];
    my $wordlist = $ARGV[1];
    
    if ($target && $wordlist) {
        my $userAgent = LWP::UserAgent -> new();

        my $header = [
            "Accept" => "application/json",
            "Content-Type" => "application/json",
        ];

        my @verbs = (
            '', 'GET', 'POST', 'PUT', 'DELETE', 'HEAD', 'OPTIONS', 'CONNECT', 'TRACE', 'PATCH', '1337', '*',
            '@GET', 'JEFF', 'CATS', '🥰😍', '😭😢', 
        );
        
        open (my $routes, "<", $wordlist);

        while (<$routes>) {
            chomp ($_);

            my $endpoint = $target . $_;

            foreach my $verb (@verbs) {
                my $request  = new HTTP::Request($verb, $endpoint, $header);
                my $response = $userAgent -> request($request);

                my $httpCode = $response -> code;
                my $httpMessage = $response -> message();

                print "[ ! ] -> [$httpCode] | $endpoint \t [$verb] - $httpMessage\n";
            }
        }

        close ($routes);
    }
}

main();
exit;