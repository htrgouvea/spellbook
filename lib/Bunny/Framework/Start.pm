#!/usr/bin/perl

#########################################################
# Horus developed by Heitor Gouvêa                      #
# This work is licensed under MIT License               #
# Copyright (c) 2016 Heitor Gouvea                      #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

#
# UNDER DEVELOPMENT
#

package Horus::Framework::Start;

use Exporter qw(import);
use Horus::Console;
use Horus::Framework::Functions;

my $func = Horus::Framework::Functions;

@ISA    = qw(Exporter);
@EXPORT = qw(start);

sub start {
	my ($parameters) = @_;

	Horus::Console -> new();
}

1;