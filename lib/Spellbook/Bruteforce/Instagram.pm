package Spellbook::Bruteforce::Instagram {
    use strict;
    use warnings;
    use Getopt::Long;
    use Try::Tiny;
    use LWP::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $username, $file);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'       => \$help,
            'u|username=s' => \$username,
            'f|file=s'     => \$file,
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