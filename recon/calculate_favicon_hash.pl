#!/usr/bin/env perl

# https://twitter.com/brsn76945860/status/1171233054951501824

use 5.018;
use strict;
use warnings;
use LWP::UserAgent;

sub main {
    my $target = $ARGV[0];

    if ($target) {
        my $userAgent = LWP::UserAgent -> new();
        my $request   = $userAgent -> get($target);
        my $httpCode  = $request -> code();

        if ($httpCode == 200) {
            my $content = $request -> content();

            print "[!] -> Hash: $hash"

        }

    }

}

main();
exit;