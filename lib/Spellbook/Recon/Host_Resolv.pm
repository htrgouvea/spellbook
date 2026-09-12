package Spellbook::Recon::Host_Resolv {
    use strict;
    use warnings;
    use Getopt::Long;
    use Net::DNS;

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

            my $resolver = Net::DNS::Resolver -> new(
                udp_timeout => 2,
                tcp_timeout => 2,
                retrans     => 2,
                retry       => 1,
                dnssec      => 0
            );

            my $search = $resolver -> search($target);

            if ($search) {
                return $target;
            }
        }

        if ($help) {
            return "\n"
                . "Recon::Host_Resolv\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Set a domain to get the IP\n";
        }

        return 0;
    }
}

1;
