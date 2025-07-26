package Spellbook::Bruteforce::SMTP {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
        );

        if ($target) {

            return @result;
        }

        if ($help) {
            return "
                \rBruteforce::SMTP
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   \n\n";
        }
    }
}

1;