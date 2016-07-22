#!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvea                      #
# This work is licensed under MIT License               #
# Copyright (c) 2016 Heitor Gouvea                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Horus::Functions;

use Switch;

my ($command, @commands);
my $func = Horus::Functions;

sub banner {

	print "\n\033[1;32m", '
/ $$  / $$
| $$  | $$
| $$  | $$  /$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$$
| $$$$$$$$ /$$__  $$ /$$__  $$| $$  | $$ /$$_____/
| $$__  $$| $$  \ $$| $$  \__/| $$  | $$|  $$$$$$
| $$  | $$| $$  | $$| $$      | $$  | $$ \____  $$
| $$  | $$|  $$$$$$/| $$      |  $$$$$$/ /$$$$$$$/
|__/  |__/ \______/ |__/       \______/ |_______/', "\033[1;37m\n\n\n";

}

sub help {
	print "\nCore Commands
	\r=============

	Command       Description
	-------       -----------
	?             Help menu
	help          Help menu
	clear         Clean the console
	exit          Exit the console
	quit          Exit the console\n\n";

	$func -> command();
}

sub quit {
	print "\nBye! ;)\n";
	exit;
}

sub clear {
	system ("clear");
	$func -> command();
}

sub error {
	print "\n[!] WARNING: an error occurred, check your command!\n";
	$func -> command();
}

sub set {
	# under development
	$func -> command();
}

sub command {
	print "\n\033[1;32m➜ \033[1;37m horus> ";
	chomp ($command = <STDIN>);

	@commands = split (/ /, $command);

	switch ($commands[0]) {
		case "?"     { $func -> help(); }
		case "help"  { $func -> help(); }
		case "exit"  { $func -> quit(); }
		case "quit"  { $func -> quit(); }
		case "set"   { $func -> set(); }
		case ""      { $func -> command(); }
		case "clear" { $func -> clear(); }
		else { $func -> error(); }
	}
}

1;
