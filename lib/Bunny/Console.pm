#!/usr/bin/perl

#########################################################
# Bunny developed by Heitor Gouvêa                      #
# This work is licensed under MIT License               #
# Copyright (c) 2016 Heitor Gouvea                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Bunny::Console;

use Switch;
use Bunny::Framework::Functions qw(set);

my ($command, @commands);

sub new {
	my $func = Bunny::Framework::Functions;

	print "\n\033[1;32m➜ \033[1;37m bunny> ";
	chomp ($command = <STDIN>);

	@commands = split (/ /, $command);

	switch ($commands[0]) {
		case ""       { new(); }
		case "?"      { $func -> help(); }
		case "help"   { $func -> help(); }
		case "exit"   { $func -> quit(); }
		case "quit"   { $func -> quit(); }
		case "start"  { $func -> start(@commands); }
		case "search" { $func -> search($command[1]); }
		case "clear"  { $func -> clear(); }
		else { $func -> error(); }
	}
}

1;