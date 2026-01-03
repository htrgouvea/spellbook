package Spellbook::Recon::DNS_Bruteforce {
    use strict;
    use warnings;
    use Spellbook::Helper::Read_File;
    use Spellbook::Recon::Host_Resolv;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);
        my $wordlist = './files/subdomains.txt';

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'f|file=s'   => \$wordlist
        );

        if (($target) && ($wordlist)) {
            my @file = Spellbook::Helper::Read_File -> new (['--file' => $wordlist]);

            if (@file) {
                foreach my $line (@file) {
                    my $return = Spellbook::Recon::Host_Resolv -> new (['--target' => "$line.$target"]);

                    if ($return) {
                        push @result, "$line.$target";
                    }
                }
            }

            return @result;
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