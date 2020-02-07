#!/usr/bin/env perl

# Use: $ perl bdorks.pl https://target.com

use 5.018;
use strict;
use warnings;
use WWW::Mechanize;

sub main {
    my $domain = $ARGV[0];

    if ($domain) {
        my $mech = WWW::Mechanize -> new();
        my %seen = ();
        my @urls = ();

        my @dorks = (
            "site:$domain intitle:index.of",
            "site:$domain intext:(password | passcode | senha | login | username | userid | user)",
            "site:$domain intext:(restrito | confidencial | interno | private | restricted | internal)",
            "site:$domain filetype:(pdf | txt | docx | sql | csv | xlsx)",
            "site:pastebin.com $domain",
            "site:trello.com $domain",
            # "site:$domain inurl: redirect url uri"
        );

        foreach my $dork (@dorks) {
            for (my $page = 0; $page <= 5; $page++) {
                my $url = "http://www.bing.com/search?q=" . $dork . "&first=" . $page . "0";
                        
                $mech -> get($url);
                my @links = $mech -> links();
                        
                foreach my $link (@links) {
                    $url = $link -> url();
                    next if $seen{$url}++;

                    if ($url =~ m/^https?/ && $url !~ m/bing|live|microsoft|msn/) {
                        print "[!] - $url\n";
                    }
                }
            }
        }
    }
}

main();
exit;