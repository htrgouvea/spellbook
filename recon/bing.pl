#!/usr/bin/env perl

# Use: $ perl bing.pl target.com

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
            "site:$domain filetype:(pdf | txt | docx | sql | csv | xlsx | ovpn)",
            "site:pastebin.com intext:$domain",
            "site:trello.com intext:$domain",
            "site:github.com intext:$domain",
            "site:dontpad.com intext:$domain",
            "site:mindmeister.com intext:$domain",
            "site:stackoverflow.com intext:$domain",
            "site:ideone.com | site:codebeautify.org | site:codeshare.io | site:codepen.io | site:repl.it | site:justpaste.it | site:jsfiddle.net $",
            "site:$domain inurl:(pydio_public | pydio-public | public_pydio | public-pydio | pydio/public/ | public/pydio/ | pydio)"
        );

        foreach my $dork (@dorks) {
            print "\n[-] DORK: $dork\n";

            for (my $page = 0; $page <= 10; $page++) {
                my $url = "http://www.bing.com/search?q=" . $dork . "&first=" . $page . "0";
                        
                $mech -> get($url);
                my @links = $mech -> links();
                        
                foreach my $link (@links) {
                    $url = $link -> url();
                    next if $seen{$url}++;

                    if ($url =~ m/^https?/ && $url !~ m/bing|live|microsoft|msn/) {
                        print "[+] $url\n";
                    }
                }
            }
        }
    }
}

main();
exit;
