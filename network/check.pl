#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use Net::Ping;

sub main {
  my $target = $ARGV[0];

  if ($target) {
    $target =~ s/https:\/\/// || $target =~ s/http:\/\/// || $target =~ s/www.//;

    my $checkHost = Net::Ping -> new( $> ? "tcp" : "icmp", 3);
    my $ping = $checkHost -> ping ($target);

    if ($ping) {
      print "$target\n";
    }

    $checkHost -> close();
  }
}

main();
exit;
