package Spellbook::Core::Helper {
	use strict;
	use warnings;

	sub new {
		return<<"EOT";

Spellbook v0.3.6
Core Commands
==============
Command          Description
-------          -----------
-s, --search     List modules, you can filter by category
-m, --module     Define a module to use
-h, --help       To see help menu of a module\n\n";

EOT
	}
}

1;