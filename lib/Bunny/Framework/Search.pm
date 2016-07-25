 #!/usr/bin/perl

#########################################################
# Bunny developed by Heitor Gouvea                      #
# This work is licensed under MIT License               #
# Copyright (c) 2016 Heitor Gouvea                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

#
# This feature is in development
#

package Bunny::Framework::Search;

use JSON;
use LWP::UserAgent;

my $ua   = LWP::UserAgent -> new;
my $func = Bunny::Functions;

sub new {
	my $api = "";

	my $request = $ua -> get ($api);
	my $httpCode = $request -> code;

	if ($httpCode == "200") {

		my $data = decode_json ($request -> content);

		my $name = $data -> {'name'};
		my $desc = $data -> {'desc'};

		print "\n$name - $desc\n";
	}

	else {
		$func -> error();
	}

}

1;