#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use XML::Simple;

sub main {
    my $file = $ARGV[0];

    if ($file) {
        my $data = XMLin($file);
        
        print "here\n";
    }
}

main();
exit;