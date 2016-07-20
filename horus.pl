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

use 5.010;
use lib "./lib/";
use Horus::Crawler;
use Horus::Functions;

sub start {
  my $func = Horus::Functions;

  $func -> banner();
  $func -> command();
}

start();
