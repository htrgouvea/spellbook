package Spellbook::Recon::Get_IP {
    use strict;
    use warnings;
    use Socket;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target =~ /^http(s)?:\/\//x) {
                $target =~ s/^http(s)?:\/\///x;
            }

            my $ip = gethostbyname($target);

            if ($ip) {
                return inet_ntoa($ip);
            }       
        }

        if ($help) {
            return "
                \rRecon::Get_IP
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set a domain to get the IP\n\n";
        }

        return 0;
    }
}

1;