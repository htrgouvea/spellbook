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
            return<<"EOT";

Recon::Get_IP
=====================
-h, --help     See this menu
-t, --target   Set a domain to get the IP\n\n";

EOT
        }

        return 0;
    }
}

1;