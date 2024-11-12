package Spellbook::Bruteforce::Twitter {
    use strict;
    use warnings;

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
            return<<"EOT";

Bruteforce::Twitter
=====================
-h, --help     See this menu
-t, --target   \n\n";

EOT
        }
    }
}

1;