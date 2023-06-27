package Spellbook::Recon::Internal_DNS {
    use strict;
    use warnings;
    use Spellbook::Recon::Get_IP;
    use Net::IP;

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            my $resolv = Spellbook::Recon::Get_IP -> new(["--target" => $target]);
            my $check  = Net::IP -> new($resolv);

            if (($check -> iptype() eq "PRIVATE") || ($check -> iptype() eq "LOOPBACK")) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
             return "
                \rRecon::Internal_DNS
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set a domain to get the IP\n\n";
        }

        return 0;
    }
}

1;