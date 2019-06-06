#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use WWW::Mechanize;

sub main {
    my $url = $ARGV[0];

    if ($url) {
        my $mech = WWW::Mechanize -> new();

        $mech -> get($url);

        my @links = $mech -> links();
        my %seen  = ();
        
        foreach my $link (@links) {
            $url = $link -> url();
            next if $seen{$url}++;

            print "$url\n";
        }
    }
}

main();
exit;