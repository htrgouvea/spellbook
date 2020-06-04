package Core::Helper;

use strict;
use warnings;

sub new {
    print "
        \rSpellbook v0.0.4
		\rCore Commands
		\r==============
		\r\tCommand       Description
		\r\t-------       -----------
		\r\t--show        List modules, you can filter by category
		\r\t--module      Set a module to use
		\r\t--read        Read the code of a module\n\n";
    
    return 1;
}

1;