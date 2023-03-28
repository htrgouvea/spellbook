package Spellbook::Core::Helper {
	use strict;
	use warnings;

	sub new {
		print "
			\rSpellbook v0.3.0
			\rCore Commands
			\r==============
			\r\tCommand          Description
			\r\t-------          -----------
			\r\t-s, --search     List modules, you can filter by category
			\r\t-m, --module     Define a module to use
			\r\t-h, --help       To see help menu of a module\n\n";
		
		return 1;
	}
}

1;