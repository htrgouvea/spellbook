 #!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvêa                      #
# This work is licensed under MIT License               #
# Copyright (c) 2017 Heitor Gouvêa                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hgouvea@protonmail.com              #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Chefy::Framework::Find;

use JSON;
use LWP::UserAgent;
use Exporter qw(import);
use Chefy::Console;
use Chefy::Framework::Functions;

my $ua   = LWP::UserAgent -> new;
my $func = Chefy::Framework::Functions;
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

	Chefy::Console -> new();
}

1;
