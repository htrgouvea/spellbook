package Spellbook::Helper::Uniq {
    use strict;
    use warnings;
    use List::MoreUtils qw(uniq);

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            'v|target=s' => \$target
        );

        if ($target) {
            return uniq $target;
        }

        if ($help) {
            return "\n"
                . "Helper::Uniq\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-v, --target    Define a value\n\n";
        }

        return 0;
    }
}

1;