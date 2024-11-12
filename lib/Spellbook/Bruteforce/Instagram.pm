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
            return<<"EOT";

Exploit::Brute_Force_Instagram
=======================
-h, --help       See this menu
-u, --username   Define a username
-f, --file       Define a file to read\n\n";

EOT
        }

        return 0;
    }
}

1;