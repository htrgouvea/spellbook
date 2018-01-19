#!/usr/bin/perl

# A simple portscan write in Perl
# Use: ./portscan.pl target.com 20 30
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use Socket;
use warnings;

sub main {
  if (@ARGV >= 2) {
    my $protocol = getprotobyname ("tcp");
    my $target = inet_aton ($ARGV[0]);

    socket (my $socket, AF_INET, SOCK_STREAM, $protocol);

    print "\nPORT \tSTATE \t SERVICE\n";

    for ($ARGV[1]..$ARGV[2]) {
      my $port = $_;
      my $connection = sockaddr_in ($port, $target);

      if (connect ($socket, $connection) ) {
        my $service = getservbyport ($port, 'tcp') || "unknown";

        print "$port \t open \t $service \n";
      }
    }

    print "\n[!] Scanning finished\n";
    close ($socket)
  }
}

main();
exit;
