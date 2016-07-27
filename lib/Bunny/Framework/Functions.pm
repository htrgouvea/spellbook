#!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvêa                      #
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
	quit          Exit the console
	search        Search for a module by name
	start         Start a module by name\n\n";

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

1;
