#!/usr/bin/env perl
# Usage: perl amass.pl amass-output.json

use 5.018;
use strict;
use warnings;
use JSON;

sub main {
    my $file = $ARGV[0];

    if ($file) {
        open (my $domains, "<", $file);

        while (<$domains>) {
            chomp($_);
            
            my $data = decode_json($_);
            print $data -> {name}, "\n";
        }

        close ($domains);
    }
}

main();
exit;
