#!/usr/bin/perl

package Horus::Functions;

use Switch;
use strict;
use warnings;

my ($command, @commands);

sub banner {

	print "\n", '
/ $$  / $$
| $$  | $$
| $$  | $$  /$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$$
| $$$$$$$$ /$$__  $$ /$$__  $$| $$  | $$ /$$_____/
| $$__  $$| $$  \ $$| $$  \__/| $$  | $$|  $$$$$$
| $$  | $$| $$  | $$| $$      | $$  | $$ \____  $$
| $$  | $$|  $$$$$$/| $$      |  $$$$$$/ /$$$$$$$/
|__/  |__/ \______/ |__/       \______/ |_______/', "\n\n";

}

sub help {

}

sub command {
		print "\n\n➜ horus: ";
	 	chomp ($command = <STDIN>);

		@commands = split (/ /, $command);

		switch ($commands[0]) {
			case "help" {
				Horus::Functions -> help();
			}

			case "set" {

			}

			else {
				Horus::Functions -> error();
			}
		}

}

sub error {
	print "\n[!] WARNING: .\n";
}

1;
