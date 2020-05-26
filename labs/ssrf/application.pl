#!/usr/bin/env perl
# Use: perl application.pl daemon -m production -l http://*:8002
# Try discover the internal hostname

use 5.018;
use strict;
use warnings;
use Mojo::URL;
use Mojo::UserAgent;
use Mojolicious::Lite -signatures;

get "/" => sub ($request) {
    my $read = $request -> param("read");

    if (($read) && (length($read) <= 52)) { 
        my $url    = Mojo::URL -> new($read);
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
                "1ynrnhl.xip.io", "0251.00376.000251.0000376", "customer2-app-169-254-169-254.nip.io",
                "owasp.org.169.254.169.254.nip.io", "app-169-254-169-254.nip.io", "ssrf-cloud.localdomain.pw",
                "ssrf-169.254.169.254.localdomain.pw", 
            );

            foreach my $hit (@blacklist) {
                if ($host eq $hit) {
                    return ($request -> render ( 
                        text => "Sorry bro! You can do it better!!!"
                    )); 
                }
            }

            my $getContent = $userAgent -> get($read) -> result();

            if ($getContent -> is_success) {
                my $content = $getContent -> body();

                return ($request -> render ( 
                    text => "
                    <html>
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
        text => "<script>window.location='/?read=https://nozaki.io/js/app.js'</script>"
    ));
};

app -> start();
