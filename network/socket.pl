#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use IO::Socket::INET;

sub main {
    my $target = $ARGV[0];

  	if ($target) {
    	$target =~ s/https:\/\/// || $target =~ s/http:\/\/// || $target =~ s/www.//;

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
