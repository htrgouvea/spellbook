#!/usr/bin/perl

use IO::Socket;

sub print_c { (ord($_[0]) >= 33 && ord($_[0]) <= 126) ? print $_[0] : print '.'; }

my $sniffer = new IO::Socket::INET->new( Type => SOCK_RAW ) || die($!);
my $x = 0;
my $j = 0;

print "\n[+] Running ...\n\n";

while (my $packet = <$sniffer>) {

 print "\n[+] Captured package:\n";

 my @rr = unpack("(H2)*", $packet);
 my $size = scalar(@rr);

 print "\n0x0000:  ";
 my $aux = 0;

 for (my $i = 0; $i < $size; $i += 2) {
  print $rr[($i-1)].$rr[$i]." ";

  $j++;

  if ($j >= 8) {
    for (my $f = $aux; $f <= $i; $f++) {
      my $p = pack("H*", $rr[$f]);
      print_c $p;
   }

    $aux = $i + 1;
    $j = 0;

    last if ($aux >= $size);
    $x++;

    printf "\n0x%03d0:  ", $x;
    }
  }

  if ($j != 0) {
    printf "\n%49s", "";
    for (my $g=($aux); $g < $size; $g++) {
      my $p = pack("H*", $rr[$g]);
      print_c $p;
    }
  }

  $x = 0;
  $j = 0;
  print "\n\n[*] End\n";
}

snif
