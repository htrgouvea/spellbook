#!/usr/bin/perl

# View dns of a target
# Use: ./dns.pl target.com
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use Net::DNS;
use IO::Select;

sub main {
	my $target = $ARGV[0];

	if ($target) {
		my $timout = 5;
		my $res     = new Net::DNS::Resolver;
		my $bgsock  = $res -> bgsend ($target);
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
	}
}

main();
exit;
