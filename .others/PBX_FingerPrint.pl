#!/usr/bin/perl -wU

=info

Checks for Alcatel 4400, sending TCP data on port 2533 / looking for specific reply to perform fingerprinting
 
Original paper : http://seclists.org/pen-test/2006/Jun/355

Exemple:
	[shell]#perl PBX_FingerPrint.pl -s 192.168.1.110
	[+] ALCATEL 4400 checker.

	192.168.1.110 seems to be an Alcatel 4400 PBX

=cut

use 5.010;
use Getopt::Std;
use IO::Socket::INET;



say"[+] ALCATEL 4400 checker.\n";

getopts('s:', \%args);

if(not(defined($args{s}))){
	usage();
}

my $data = "\x43";
my $size = "\x00\x01";

my $serv = $args{s};
my $port = 2533;
my $buf = $size . $data;

if($socket = new IO::Socket::INET(PeerAddr => $serv, PeerPort => $port, Proto => "tcp", Timeout => 1)){

	print $socket $buf;
	read($socket,$chunk,2);


	if($chunk & "\x00\x01"){
		say "[+]$serv seems to be an Alcatel 4400 PBX \n";
	}else{
		say "[-]$serv doesn't look like an Alcatel 4400 PBX \n";
	}
}else{ 
	say "$serv is not an Alcatel 4400\n";
	exit;
}

sub usage{
	die("\n[*] Usage: $0 -s <server>\n\n");
	exit(0);
}
