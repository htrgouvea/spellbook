#!/usr/bin/env perl
# Use: perl best-cloud-security.pl daemon -m production -l http://*:8003
# Try pop up some thing on browser

use 5.018;
use strict;
use warnings;
use Mojo::URL;
use Mojo::UserAgent;
use Mojolicious::Lite -signatures;

get "/" => sub ($request) {
    my $param = $request -> param("get");

    if (($param) && (length($param) <= 52)) { 
        my $url = Mojo::URL -> new($param);

        my $scheme = $url -> scheme;

        if ($scheme) {
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
                "localhost", "0.0.0.0", "127.0.0.1", "127.0.0.2", "169.254.169.254", "instance-data",
                "0:0:0:0:0:ffff:a9fe:a9fe", "::ffff:a9fe:a9fe", "[::]", "0000::1", "0xA9.0xFE.0xA9.0xFE",
                "0251.00376.000251.0000376", "169.254.169.254.xip.io", "www.owasp.org.1ynrnhl.xip.io",
                "1ynrnhl.xip.io", "0251.00376.000251.0000376"
            );

            foreach my $hit (@blacklist) {
                if ($host eq $hit) {
                    return ($request -> render ( 
                        text => "Sorry bro! You can do it better!!!"
                    )); 
                }
            }

            my $getContent = $userAgent -> get($param) -> result();

            if ($getContent -> is_success) {
                my $content = $getContent -> body();

                return ($request -> render ( 
                    text => "<html>
                        <head>
                            <title>Awesome Web Security - AWS</title>
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
        
    }
    
    return ($request -> render (
        text => "<script>window.location='/?get=https://nozaki.io/images/evie_default_bg.jpeg'</script>"
    ));
};

app -> start();