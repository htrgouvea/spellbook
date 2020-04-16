#!/usr/bin/env perl
# Usage: perl extract_links.pl https://target.com  # draft code / i need implement recursive function

use 5.018;
use strict;
use warnings;
use WWW::Mechanize;

sub main {
    my $target = $ARGV[0];

    if ($target) {
        my $mech    = WWW::Mechanize -> new();
        my $request = $mech -> get($target);
        my $status  = $mech -> status();

        if ($status == "200") {
            my @links = $mech -> links();

            for my $link (@links) {
                print $link -> url(), "\n";
            }
        }
    }
}

main();
exit;