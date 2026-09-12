package Spellbook::Recon::Get_IP {
    use strict;
    use warnings;
    use Getopt::Long;
    use Socket;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target =~ /^http(s)?:\/\//msx) {
                $target =~ s/^http(s)?:\/\///msx;
            }

            my $ip = gethostbyname $target;

            if ($ip) {
                return inet_ntoa($ip);
            }
        }

        if ($help) {
            return "\n"
                . "Recon::Get_IP\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Set a domain to get the IP\n";
        }

        return 0;
    }
}

1;
