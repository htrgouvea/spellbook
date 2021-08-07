package Spellbook::Helper::Generate_UUID {
    use strict;
    use warnings;
    use UUID::Tiny ':std';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $version, $repeat, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "v|version=i" => \$version,
            "r|repeat=i" => \$repeat
        );

        if ($version) {
            for (my $i = 0; $i <= $repeat; $i++) {
                my $generate = create_uuid_as_string($version);
                push @result, $generate;
            }
            
            return @result;
        }

        if ($help) {
            return "
                \rHelper::Generate_UUID
                \r=====================
                \r-h, --help     See this menu
                \r-v, --version  Version of UUID algorithm
                \r-r, --repeat   Quantities of repetitions\n\n";
        }

        return 0;
    }
}

1;