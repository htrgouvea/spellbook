package Spellbook::Recon::Host_Resolv {
    use strict;
    use warnings;
    use Net::DNS;

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

            my $resolver = Net::DNS::Resolver -> new();
            my $search   = $resolver -> search($target);

            if ($search) {
                return $target;
            }
        }

        if ($help) {
            return<<"EOT";

Recon::Host_Resolv
=====================
-h, --help     See this menu
-t, --target   Set a domain to get the IP\n\n";

EOT
        }

        return 0;
    }
}

1;