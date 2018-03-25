#!/usr/bin/perl

# View dns of a target
# Use: ./dns.pl target.com
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use Net::DNS;
use IO::Select;

my $timout = 5;
my $res     = new Net::DNS::Resolver;
my $bgsock  = $res -> bgsend ("heitorgouvea.me");
my $sel     = IO::Select -> new ($bgsock);
my @ready   = $sel -> can_read ();

if (@ready) {
	foreach my $sock (@ready) {
		if ($sock == $bgsock) {
			my $packet = $res -> bgread ($bgsock);

			$packet -> print;
	    $bgsock = undef;
		}

		$sel -> remove($sock);
	  $sock = undef;
	}
}
