package Spellbook::Core::Helper {
	use strict;
	use warnings;

	sub new {
		print "
			\rSpellbook v0.0.7
			\rCore Commands
			\r==============
			\r\tCommand          Description
			\r\t-------          -----------
			\r\t-s, --search     List modules, you can filter by category
			\r\t-m, --module     Set a module to use
			\r\t-t, --target     Set a target
			\r\t-p, --parameter  Set a value for a module parameter\n\n";
		
		return 1;
	}
}

1;