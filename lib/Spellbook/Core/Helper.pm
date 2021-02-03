package Spellbook::Core::Helper;

use strict;
use warnings;

sub new {
    print "
        \rSpellbook v0.0.6
		\rCore Commands
		\r==============
		\r\tCommand       Description
		\r\t-------       -----------
		\r\t-s, --show        List modules, you can filter by category
		\r\t-m, --module      Set a module to use\n\n";
    
    return 1;
}

1;