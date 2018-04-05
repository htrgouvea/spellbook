#!/usr/bin/perl

# Simple script to decode base64 strings
# Use: ./base64.pl "YmFzZTY0Cg=="
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use MIME::Base64;

sub main {
  my $string = $ARGV[0];

  if ($string) {
    my $decoded = MIME::Base64::decode($string);

    print $decoded;
  }
}

main();
exit;
