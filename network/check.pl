#!/usr/bin/perl

# Checkhosts by a domain list via ICMP connection
# Use: ./check.pl targets.txt
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use Net::Ping;

sub main {
  my $target = $ARGV[0];

  if ($target) {
    my $checkHost = Net::Ping -> new();

    if ($checkHost -> ping ($target)) {
      print "$target\n";
    }
  }
}

main();
exit;
