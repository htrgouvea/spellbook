package Spellbook::Helper::Generate_UUID {
    use strict;
    use warnings;
    use UUID::Tiny ':std';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $version, @result);

        my $repeat = 1;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"      => \$help,
            "v|version=i" => \$version,
            "r|repeat=i"  => \$repeat
        );

        if ($version) {
            for (my $i = 1; $i <= $repeat; $i++) {
                my $generate = create_uuid_as_string($version);

                push @result, $generate;
            }

            return @result;
        }

        if ($help) {
            return<<"EOT";

Helper::Generate_UUID
=====================
-h, --help     See this menu
-v, --version  Version of UUID algorithm
-r, --repeat   Quantities of repetitions\n\n";

EOT
        }

        return 0;
    }
}

1;