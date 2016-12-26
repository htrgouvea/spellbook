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

package Horus::Console;

use Switch;
use Horus::Framework::Functions;
use Horus::Framework::Find qw(find);
use Horus::Framework::UseModule qw(UseModule);

my ($command, @commands);

sub new {
	my $func = Horus::Framework::Functions;

	print "\n\033[1;32m➜ \033[1;37m horus> ";
	chomp ($command = <STDIN>);

	@commands = split (/ /, $command);

	switch ($commands[0]) {
		case ""      { new(); }
		case "?"     { $func -> help(); }
		case "help"  { $func -> help(); }
		case "exit"  { $func -> quit(); }
		case "quit"  { $func -> quit(); }
		case "clear" { $func -> clear(); }
		case "use" { UseModule(@commands); }
		case "find"  { find("$commands[1]"); }
		else { $func -> error(); }
	}
}

1;