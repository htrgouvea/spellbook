package Spellbook::Core::Helper;

use strict;
use warnings;

sub new {
    print "
        \rSpellbook v0.0.6
		\rCore Commands
		\r==============
		\r\tCommand         Description
		\r\t-------         -----------
		\r\t-s, --search    List modules, you can filter by category
		\r\t-m, --module    Set a module to use
		\r\t-t, --target    Set a target\n\n";
    
    return 1;
}

1;