#!/usr/bin/env perl

# Use: $ perl contenttype_fuzzer.pl https://target.com/api/v1/endpoint

use 5.018;
use strict;
use warnings;
use HTTP::Request;
use LWP::UserAgent;

sub main {
    my $target = $ARGV[0];

    if ($target) {
        print "here\n";
    }
}

main();
exit;