#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex);

sub main {
    my $value = $ARGV[0];

    if ($value) {
        for (my $i = 0; $i <= 100000; $i++) {
            my $hash = md5_hex($i);
            
            my $new = substr($hash, 0, 4);

            if ($new eq $value ) {
                print "[!] $i - $hash -> $value\n";
            }
        }
    }
}

main();
exit;