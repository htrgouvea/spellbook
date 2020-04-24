#!/usr/bin/env perl
# Usage: perl nmap.pl <nmap_output_file.xml>

use 5.018;
use strict;
use warnings;
use XML::Simple;

sub main {
    my $file = $ARGV[0];

    if ($file) {
        my $xml  = XML::Simple -> new();
        my $data = $xml -> XMLin($file);
        my $host = $data -> {host} -> {address} -> {addr};
        
        print "\n$host\n"; 

        foreach my $content (@{$data -> {host} -> {ports} -> {port}}) {
            my $state = $content -> {state} -> {state};

            if (($state eq "open") || ($state eq "filtered")) {
                my $port     = $content -> {portid};
                my $protocol = $content -> {protocol};
                my $service  = $content -> {service} -> {name};

                print "[$protocol] | [$state]-> $port \t | $service\n";
            }
        };
    }
}

main();
exit;