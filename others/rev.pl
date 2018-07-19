#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

sub main {
	my $string = $ARGV[0];

	if ($string) {
		print scalar reverse $string;
	}
}

main();
exit;