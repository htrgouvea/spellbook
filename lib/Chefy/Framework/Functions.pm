#!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvêa                      #
# This work is licensed under MIT License               #
# Copyright (c) 2017 Heitor Gouvêa                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hgouvea@protonmail.com              #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Chefy::Framework::Functions;

use Switch;
use Chefy::Console;

sub banner {
	# print "\n\033[1;32m", '', "\033[1;37m\n";
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
	use           Use a module by name\n\n";

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
	Chefy::Console -> new();
}

1;
