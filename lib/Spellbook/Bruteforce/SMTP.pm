package Spellbook::Bruteforce::SMTP {
    use strict;
    use warnings;
    use Getopt::Long;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
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