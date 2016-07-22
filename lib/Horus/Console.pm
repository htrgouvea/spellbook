#!/usr/bin/perl

package Horus::Console;

use Switch;
use Horus::Functions;

my ($command, @commands);

sub new {
	my $func = Horus::Functions;

	print "\n\033[1;32m➜ \033[1;37m horus> ";
	chomp ($command = <STDIN>);

	@commands = split (/ /, $command);

	switch ($commands[0]) {
		case "?"     { $func -> help(); }
		case "help"  { $func -> help(); }
		case "exit"  { $func -> quit(); }
		case "quit"  { $func -> quit(); }
		case "set"   { $func -> set(); }
		case "start" { $func -> start(); }
		case ""      { $func -> command(); }
		case "clear" { $func -> clear(); }
		else { $func -> error(); }
	}
}

1;