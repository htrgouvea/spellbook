package Spellbook::Helper::Generate_UUID {
    use strict;
    use warnings;
    use UUID::Tiny ':std';

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $version, @result);

        my $repeat = 1;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'      => \$help,
            'v|version=i' => \$version,
            'r|repeat=i'  => \$repeat
        );

        if ($version) {
            foreach (1 .. $repeat) {
                my $generate = create_uuid_as_string($version);

                push @result, $generate;
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Helper::Generate_UUID\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-v, --version  Version of UUID algorithm\n"
                . "-r, --repeat   Quantities of repetitions\n\n";
        }

        return 0;
    }
}

1;
