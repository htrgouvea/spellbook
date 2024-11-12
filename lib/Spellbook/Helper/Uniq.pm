package Spellbook::Helper::Uniq {
    use strict;
    use warnings;
    use List::MoreUtils qw(uniq);
    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"    => \$help,
            "v|target=s" => \$target
        );

        if ($target) {
            return uniq $target;
        }

        if ($help) {
            return<<"EOT";

Helper::Uniq
=====================
-h, --help     See this menu
-v, --target    Define a value\n\n";

EOT
        }

        return 0;
    }
}

1;