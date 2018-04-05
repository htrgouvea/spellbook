#!/usr/bin/perl

# A simple dns brute write in Perl
# Use: ./dnsbrute.pl target.com wordlists/subdomains.txt
# Heitor Gouvêa - hi@heitorgouvea.me

use 5.010;
use strict;
use warnings;
use Net::Ping;

sub main {
  if (@ARGV >= 2) {
    my $target = $ARGV[0];
    my $wordlist = $ARGV[1];

    $target =~ s/https:\/\/// || $target =~ s/http:\/\/// || $target =~ s/www.//;

    my $p = Net::Ping -> new();

    open (my $subdomains, "<", $wordlist);

     while (my $row = <$subdomains>) {
       chomp ($row);

       my $target = $row . $target;

       if ($p->ping($target)) {
        say 'alive';
      }
     }

     close ($subdomains);
  }
}

main();
exit;
