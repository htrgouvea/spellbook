#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use LWP::UserAgent;

sub main {
    my $target = $ARGV[0];

    if ($target) {
        my $userAgent = LWP::UserAgent -> new();
        
        $userAgent -> timeout(15);
        $userAgent -> agent ("Mozilla/5.0 (Windows; U; Windows NT 5.1; en; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4");
        
        open (my $wordlist, "<", "wordlists/admin-pages.txt");

        while (<$wordlist>) {
            chomp ($_);

            my $request  = $userAgent -> get("$target/$_");
            my $httpCode = $request -> code();

            if ($httpCode == "200") {
                print "[!] -> $target/$_\n";
            }
        }

        close ($wordlist);
    }
}

main();
exit;