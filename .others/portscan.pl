#!/usr/bin/perl

use 5.010;
use strict;
use Socket;
use warnings;

sub main {
	if (@ARGV >= 1) {
    	my $protocol = getprotobyname ("tcp");
    	my $target   = inet_aton ($ARGV[0]);

    	$target =~ s/https:\/\/// || $target =~ s/http:\/\/// || $target =~ s/www.//;

    	socket (my $socket, AF_INET, SOCK_STREAM, $protocol);

    	my $port = $ARGV[1];
    	my $connection = sockaddr_in ($port, $target);

    	if (!connect ($socket, $connection) ) {
      		my $service = getservbyport ($port, 'tcp') || "unknown";
      		print "$ARGV[0] ~> $port | $service \n";
    	}

    	close ($socket);
  	}
}

main();
exit;
