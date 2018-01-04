#!/usr/bin/perl

# Checkhosts by a domain list via ICMP connection
# Use: ./check.pl targets.txt
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use Net::Ping;

sub main {
  if ($ARGV[0]) {
    open (my $targets, "<", $ARGV[0]);

    while (my $target = <$targets>) {
      chomp($target);

      my $checkHost = Net::Ping -> new();

      if ($checkHost -> ping ($target)) {
        print "$target\n";
      }
    }

    close ($targets);
  }
}

main();
exit;
