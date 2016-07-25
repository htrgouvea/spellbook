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

package Bunny::Framework::Functions;

use Switch;
use Bunny::Console;
use Exporter qw(import);

our @EXPORT_OK = qw(set);

my $func = Bunny::Framework::Functions;

sub banner {

	print "\n\033[1;32m", '
/$$$$$$$                                         
| $$__  $$                                        
| $$  \ $$ /$$   /$$ /$$$$$$$  /$$$$$$$  /$$   /$$
| $$$$$$$ | $$  | $$| $$__  $$| $$__  $$| $$  | $$
| $$__  $$| $$  | $$| $$  \ $$| $$  \ $$| $$  | $$
| $$  \ $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$
| $$$$$$$/|  $$$$$$/| $$  | $$| $$  | $$|  $$$$$$$
|_______/  \______/ |__/  |__/|__/  |__/ \____  $$
                                         /$$  | $$
      Developed by Heitor Gouvea        |  $$$$$$/
                                         \______/', "\033[1;37m\n";

}

sub help {
	print "\nCore Commands
	\r=============

	Command       Description
	-------       -----------
	?             Show help menu
	help          Show help menu
	clear         Clean the console
	exit          Exit the console
	quit          Exit the console\n\n";

	Bunny::Console -> new();
}

sub quit {
	print "\nBye! ;)\n";
	exit;
}

sub clear {
	my $sys = $^O;
	my $clear;

	if ($sys eq "MSWin32") {
    	$clear = "cls";
	}

	else {
    	$clear = "clear";
	}

	system ($clear);
	
	Bunny::Console -> new();
}

sub error {
	print "\n[!] WARNING: an error occurred, check your command!\n";
	Bunny::Console -> new();
}


## UNDER DEVELOPMENT
sub set {
	my $function = @_;

	switch ($function) {
		case "" {
			$func -> error();
		}

		case "help" {
			print "\nhelp\n";
		}

		case "dork" {
			print "\ndork\n";
		}

		case "exploit" {
			print "\nexploit\n";
		} 

		case "output" {
			print "\noutput\n";
		}

		case "offset" {
			print "\noffset\n";
		}

		case "limit" {
			print "\nlimit\n";
		}

		else {
			$func -> error();
		}
	}
	Bunny::Console -> new();
}

1;
