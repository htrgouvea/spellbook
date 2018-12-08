#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use Net::Ping;

sub main {
    my $target = $ARGV[0];

    if ($target) {
        $target =~ s/https:\/\/// || $target =~ s/http:\/\/// || $target =~ s/www.//;
        
        my $ping = Net::Ping -> new("tcp");

        if ($ping -> ping($target)) {
            print "$target\n";
        }
  }
}

main();
exit;