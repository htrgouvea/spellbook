#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use Text::Morse;

sub main {
  	my $string = $ARGV[0];

  	if ($string) {
    	my $morse = new Text::Morse;
    	print scalar($morse -> Decode($string));
  	}
}

main();
exit;
