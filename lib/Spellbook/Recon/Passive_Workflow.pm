package Spellbook::Recon::Passive_Workflow {
    use strict;
    use warnings;
    use Spellbook::Recon::Host_Resolv;
    use Spellbook::Recon::Get_IP;
    use Spellbook::Recon::Shodan_Enum;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            my $resolv = Spellbook::Recon::Host_Resolv -> new (["--target" => $target]);

            if ($resolv) {
                my $ip = Spellbook::Recon::Get_IP -> new (["--target" => $target]);

                if ($ip) {
                    my @shodan = Spellbook::Recon::Shodan_Enum -> new(["--target" => $ip]);

                    push @result, @shodan;
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Shodan_Enum
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set an IP to see infos on shodan API\n\n";
        }

        return 0;
    }
}

1;