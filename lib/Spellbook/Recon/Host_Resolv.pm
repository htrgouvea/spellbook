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
            my $resolver = Net::DNS::Resolver -> new();
            my $search = $resolver -> search($target);

            if ($search) {
                return $target;
            } 
        }
        
        if ($help) {
            return "
                \rRecon::Host_Resolv
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set a domain to get the IP\n\n";
        }

        return 0;
    }
}

1;