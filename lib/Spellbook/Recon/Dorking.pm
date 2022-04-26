package Spellbook::Recon::Dorking {
    use strict;
    use warnings;
    use WWW::DuckDuckGo;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $dork, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "d|dork=s" => \$dork
        );

        if ($dork) {
            my $engine = WWW::DuckDuckGo -> new() -> zci("$dork");
            
            # use Data::Dumper;
            # print Dumper($engine -> Answer());

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Dorking
                \r=====================
                \r-h, --help     See this menu
                \r \n\n";
        }

        return 0;
    }
}

1;