#!/usr/bin/perl

# Get IP by domain
# Use: ./ip.pl target.com
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use IO::Socket::INET;

sub main {
  my $target = $ARGV[0];

  if ($target) {
    $target =~ s/https:\/\/// || $target =~ s/http:\/\/// || $target =~ s/www.//;
    
    my $ipAddr = inet_ntoa (scalar gethostbyname($target));
    print "$ipAddr \n";
  }
}

main();
exit;
