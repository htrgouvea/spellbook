package Spellbook::Recon::Host_Resolv {
    use strict;
    use warnings;
    use Net::DNS;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target =~ /^http(s)?:\/\//msx) {
                $target =~ s/^http(s)?:\/\///msx;
            }

            my $resolver = Net::DNS::Resolver -> new();
            my $search   = $resolver -> search($target);

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
