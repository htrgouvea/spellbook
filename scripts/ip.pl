#!/usr/bin/perl

# Get IP by domain
# Use: ./ip.pl targets.txt
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use IO::Socket::INET;

sub main {
  if ($ARGV[0]) {
    open (my $targets, "<", $ARGV[0]);

    while (my $target = <$targets>) {
      chomp ($target);

      my $ipAddr = inet_ntoa (scalar gethostbyname($target));
      print "$ipAddr\n";
    }

    close ($targets);
  }
}

main();
exit;
