#!/usr/bin/env perl
# Use: perl awesome-waf.pl daemon -m production -l http://*:8080
# Try pop up some thing on browser

use 5.018;
use strict;
use warnings;
use Mojo::URL;
use Mojolicious::Lite -signatures;

get "/" => sub ($request) {
    my $target = $request -> param("Target");

    if ($target) { 
        my $url = Mojo::URL -> new($target);

        my $scheme = $url -> scheme || " ";
        my $userinfo = $url -> userinfo || " ";
        my $host = $url -> host || " ";
        my $port = $url -> port || " ";
        my $path = $url -> path || " ";

        say "scheme -> $scheme";
        say "userinfo -> $userinfo";
        say "host -> $host";
        say "port -> $port";
        say "path -> $path";
        say "========================";

        if ($host eq "www.whitelisteddomain.tld") {
            return ($request -> render ( 
                text => "<h3>Yay! You send to me $host!!!</h3>"
            ));    
        }
        
        return ($request -> render ( 
            text => "<h3>$host</h3>"
        )); 
    }
    
    return ($request -> render (
        text => "<script>window.location='/?Target=http://www.whitelisteddomain.tld'</script>"
    ));
};

app -> start();