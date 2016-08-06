 #!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvêa                      #
# This work is licensed under MIT License               #
# Copyright (c) 2016 Heitor Gouvea                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Horus::Framework::Find;

use JSON;
use LWP::UserAgent;
use Exporter qw(import);
use Horus::Console;
use Horus::Framework::Functions;

my $ua   = LWP::UserAgent -> new;
my $func = Horus::Framework::Functions;
my $api  = "https://api.myjson.com/bins/4r2iv";

@ISA    = qw(Exporter);
@EXPORT = qw(find);

sub find {
	my ($keyword) = @_;

	print "
	\rName              Description
   	\r-----             ------------\n";

	my $request  = $ua -> get ($api);
	my $httpCode = $request -> code;

	if ($httpCode == "200") {
		my $data = decode_json ($request -> content);

		foreach my $elements (@$data) {
			my $name = $elements -> {'name'};
			my $desc = $elements -> {'desc'};

			if ($name =~ /$keyword/ ) {
				print "$name \t $desc\n";
			}
		}
	}

	else {
		my $httpMessage = $request -> message;
		print "\n[!] $httpCode -> $httpMessage\n";
	}

	Horus::Console -> new();
}

1;