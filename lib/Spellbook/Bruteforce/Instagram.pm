package Spellbook::Bruteforce::Instagram {
    use strict;
    use warnings;
    use Try::Tiny;
    use LWP::UserAgent;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $username, $file);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"       => \$help,
            "u|username=s" => \$username,
            "f|file=s"     => \$file,
        );

        if ($username) {
            my $useragent = LWP::UserAgent -> new();

        } 

        if ($help) {
            return "
                \rExploit::Brute_Force_Instagram
                \r=======================
                \r-h, --help       See this menu
                \r-u, --username   Define a username
                \r-f, --file       Define a file to read\n\n";
        }

        return 0;
    }
}

1;