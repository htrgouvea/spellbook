#!/usr/bin/perl

# Get IP by domain

use 5.010;
use strict;
use warnings;
use IO::Socket::INET;

sub main {
  my $domain = $ARGV[0];

  if ($domain) {
    my $ipAddr = inet_ntoa (scalar gethostbyname($domain));
    print "$ipAddr\n";
  }
}

main();
exit;
