#!/usr/bin/env perl
# Usage: $ perl bing.pl target.com

use 5.018;
use strict;
use warnings;
use WWW::Mechanize;
use Mojo::Util qw( url_escape);

sub main {
    my $domain = $ARGV[0];

    if ($domain) {
        my $mech = WWW::Mechanize -> new();
        my %seen = ();
        my @urls = ();

        my @dorks = (
            "(site:$domain) && (filetype:pdf || ppt || xls || doc) && (inbody:restrito | confidencial | interno | private | restricted | internal)",
            "site:$domain intitle:\"Index of\"",
            "(site:$domain) && (inbody:login || username || user || e-mail || usuário || userid) && (inbody:senha || password || passcode)",
            "site:pastebin.com inbody:\"$domain\"",
            "site:github.com inbody:\"$domain\"",
            "site:trello.com inbody:\"$domain\"",
            "site:stackoverflow.com inbody:\"$domain\"",
            "(site:$domain) && (filetype:.bak || .sql)",
            "(site:$domain) && (inbody:\"Hacked by\" || \"Owned by\" || \"Pwned by\")"
        );

        foreach my $dork (@dorks) {
            $dork = url_escape($dork);

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
