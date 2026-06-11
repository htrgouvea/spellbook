package Spellbook::Core::Helper {
    use strict;
    use warnings;

    our $VERSION = '0.0.2';

    sub new {
        print "\n"
            . "Spellbook v0.3.8\n"
            . "Core Commands\n"
            . "==============\n"
            . "    Command          Description\n"
            . "    -------          -----------\n"
            . "    -s, --search     List modules, you can filter by category\n"
            . "    -m, --module     Define a module to use\n"
            . "    -h, --help       To see help menu of a module\n\n";

        return 1;
    }
}

1;
