#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

sub main {
  my $string = $ARGV[0];

  if ($string) {
    $string =~ s/([a-fA-F0-9][a-fA-F0-9])/chr(hex($1))/eg;
    print $string;
  }
}

main();
exit;
