package Spellbook::Recon::DNS_Bruteforce {
    use strict;
    use warnings;
    use Spellbook::Helper::Read_File;
    use Spellbook::Recon::Host_Resolv;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);
        my $wordlist = "./files/subdomains.txt";

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
            "f|file=s"   => \$wordlist
        );

        if (($target) && ($wordlist)) {
            my @file = Spellbook::Helper::Read_File -> new (["-f" => $wordlist]);

            if (@file) {
                foreach my $line (@file) {
                    my $return = Spellbook::Recon::Host_Resolv -> new (["--target" => "$line.$target"]);

                    if ($return) {
                        push @result, "$line.$target";
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return<<"EOT";

Recon::DNS_Bruteforce
=====================
-h, --help     See this menu
-t, --target   Set a domain as a target
-f, --file     Define a wordlist\n\n";

EOT
        }

        return 0;
    }
}

1;