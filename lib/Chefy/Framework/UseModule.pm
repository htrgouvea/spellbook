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


package Chefy::Framework::UseModule;

use Exporter qw(import);
use Chefy::Console;
use Chefy::Framework::Functions;

my $func = Chefy::Framework::Functions;

@ISA    = qw(Exporter);
@EXPORT = qw(UseModule);

sub UseModule {
	my ($parameters) = @_;

	Chefy::Console -> new();
}

1;
