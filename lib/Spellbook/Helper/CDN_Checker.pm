package Spellbook::Helper::CDN_Checker {
    use strict;
    use warnings;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"      => \$help,
            "t|target=s"  => \$target
        );

        if ($target) {

        }

        if ($help) {
            return "
                \rHelper::CDN_Checker
                \r=====================
                \r-h, --help     See this menu
                \r-t --target    Define a target\n\n";
        }

        return 0;
    }
}

1;