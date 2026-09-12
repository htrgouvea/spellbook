package Spellbook::Recon::DNS_Bruteforce {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Helper::Read_File;
    use Spellbook::Recon::Host_Resolv;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);
        my $wordlist = './files/subdomains.txt';

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
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
            return "\n"
                . "Recon::DNS_Bruteforce\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Set a domain as a target\n"
                . "-f, --file     Define a wordlist\n\n";
        }

        return 0;
    }
}

1;
