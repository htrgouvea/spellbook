#!/usr/bin/env perl

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

            if ($state eq "open") {
                my $port     = $content -> {portid};
                my $protocol = $content -> {protocol};
                my $service  = $content -> {service} -> {name};

                print "[$protocol] -> $port \t | $service\n";
            }
        };
    }
}

main();
exit;