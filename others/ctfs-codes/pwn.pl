#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;
use IO::Socket::INET;

sub main {
    my $host = "142.93.73.149";
    my $port = "23112";

    my $socket = IO::Socket::INET->new(
        PeerAddr => $host,
        PeerPort => $port,
        Proto    => 'tcp',
        Timeout  =>  1
    );

    if ($socket) {
        my $data = <$socket>;

        while(1) {
            my @chars = ("a", "b", "c");
            
            foreach my $char (@chars) {
                if ($socket -> send($char)) {
                    print "[ ! ]-> send -> $char\n";

                    $socket -> recv($data, 1024);
                    
                    if ($data) {
                        print $data;
                    }
                }
            }

            exit();
        }
    }
}

main();