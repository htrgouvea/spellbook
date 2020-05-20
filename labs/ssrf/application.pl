#!/usr/bin/env perl
# Use: perl best-cloud-security.pl daemon -m production -l http://*:8002
# Try pop up some thing on browser

use 5.018;
use strict;
use warnings;
use Mojo::URL;
use Mojo::UserAgent;
use Mojolicious::Lite -signatures;

get "/" => sub ($request) {
    my $read = $request -> param("read");

    if (($read) && (length($read) <= 52)) { 
        my $url = Mojo::URL -> new($read);

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

        my $userAgent = Mojo::UserAgent -> new();

        my @blacklist = (
            "localhost", "0.0.0.0", "127.0.0.1", "127.0.0.2", "169.254.169.254",
            "0:0:0:0:0:ffff:a9fe:a9fe", "::ffff:a9fe:a9fe", "[::]", "0000::1", "0xA9.0xFE.0xA9.0xFE",
            
        );

        foreach my $hit (@blacklist) {
            if ($host eq $hit) {
                return ($request -> render ( 
                    text => "Sorry bro! You can do better!!!"
                )); 
            }
        }

        my $getContent = $userAgent -> get($read) -> result();

        if ($getContent -> is_success) {
            my $content = $getContent -> body();

            return ($request -> render ( 
                text => "<html>
                    <head>
                        <title>Awesome Cloud Security</title>
                        <!-- The flag is internal hostname of this server ;) -->
                    </head>
                    <body>
                        $content
                    </body>
                    
                </html>"
                
            ));   
        }
        
        else {
            return ($request -> render ( 
                text => "
                    <h3>$host</h3>
                    <!--  Get the hostname of this server bro! -->
                "
            )); 
        }
    }
    
    return ($request -> render (
        text => "<script>window.location='/?read=https://nozaki.io/js/app.js'</script>"
    ));
};

app -> start();