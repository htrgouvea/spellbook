#!/usr/bin/env perl
# Usage: $ perl params.pl https://target.com /wordlists/http/params.txt

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