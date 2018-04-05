#!/usr/bin/perl

# A script to make socket connection
# Use: ./socket.pl target.com:80
# Heitor Gouvêa
# hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use IO::Socket::INET;

sub main {
  my $target = $ARGV[0];

  if ($target) {
    my @target = split(/:/, $target);

    my $socket = IO::Socket::INET -> new (
      PeerAddr => $target[0],
      PeerPort => $target[1],
      Proto    => "tcp",
      Reuse    => "1",
      Timeout  => "3"
    );

    if ($socket) {
      print "$target[0]:$target[1]\n";
    }
  }
}

main();
exit;
