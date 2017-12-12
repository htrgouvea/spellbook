#!/usr/bin/perl

# Checkhosts by a domain list via ICMP connection

use 5.010;
use strict;
use warnings;
use Net::Ping;

sub main {
  my $domain = $ARGV[0];

  if ($domain) {
    my $checkHost = Net::Ping -> new();

    if ($checkHost -> ping ($domain)) {
      print "$domain\n";
    }  
  }
}

main();
exit;
