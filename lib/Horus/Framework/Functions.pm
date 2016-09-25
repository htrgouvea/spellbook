#!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvêa                      #
# This work is licensed under MIT License               #
# Copyright (c) 2016 Heitor Gouvêa                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Horus::Framework::Functions;

use Switch;
use Horus::Console;

sub banner {

	print "\n\033[1;32m", '
 /$$   /$$                                        
| $$  | $$                                        
| $$  | $$  /$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$$
| $$$$$$$$ /$$__  $$ /$$__  $$| $$  | $$ /$$_____/
| $$__  $$| $$  \ $$| $$  \__/| $$  | $$|  $$$$$$ 
| $$  | $$| $$  | $$| $$      | $$  | $$ \____  $$
| $$  | $$|  $$$$$$/| $$      |  $$$$$$/ /$$$$$$$/
|__/  |__/ \______/ |__/       \______/ |_______/', "\033[1;37m\n";

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
	quit          Exit the console
	find          Find for a module by name
	start         Start a module by name\n\n";

	Horus::Console -> new();
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
	
	Horus::Console -> new();
}

sub error {
	print "\n[!] WARNING: an error occurred, check your command!\n";
	Horus::Console -> new();
}

1;
