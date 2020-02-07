#!/usr/bin/env perl

# Usage: perl aquatone.pl <file_from_aquatone.json>

use 5.018;
use strict;
use warnings;

sub main {
    my $file = $ARGV[0];

    if ($file) {
        open (my $fh, "<", $file);

        while (<$fh>) {
            chomp ($_);
            my @host = split(/,/, $_);
            
            print $host[0], "\n";
        }  

        close ($fh);
    }
}

main();
exit;