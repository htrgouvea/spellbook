#!/usr/bin/perl

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
