package Spellbook::Recon::DNS_Bruteforce {
    use strict;
    use warnings;
    use Spellbook::Helper::Read_File;
    use Spellbook::Recon::Host_Resolv;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
            "f|file=s"   => \$file
        );

        if ($target) {
            
            my $resolv = Spellbook::Recon::Host_Resolv -> new(
                ["target" => $target]
            );
        }
        
        if ($help) {
            return "
                \rRecon::DNS_Bruteforce
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set a domain as a target
                \r-f, --file     Define a wordlist\n\n";
        }

        return 0;
    }
}

1;