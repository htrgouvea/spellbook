package Spellbook::Recon::Masscan {
    use strict;
    use warnings;
    use Masscan::Scanner;
    use Data::Dumper;
    
    sub new {
        my ($self, $parameters) = @_;
        my ($help, @target, @ports, @arguments, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=s" => \@target,
            "p|port=s" => \@ports,
            "a|arguments" => \@arguments
        );

        if (@target) {
            my $masscan = Masscan::Scanner -> new(
                hosts => \@target, 
                ports => \@ports, 
                arguments => \@arguments
            );

            my $scan = $masscan -> scan();

            if ($scan) {
                my $result = $masscan -> scan_results();

                foreach my $value (@{$result -> {"scan_results"}}) {
                    print $value -> {"ip"} . ":" .  $value -> {"ports"} -> [0] -> {"port"}, "\n";
                }
            }
        } 

        if ($help) {
            return "
                \rRecon::Masscan
                \r=====================
                \r-h, --help       See this menu
                \r-t, --target     Set an Domain/IP to make a port scanning using masscan
                \r-p, --ports      Define ports to scan
                \r-a, --arguments  Parameters to masscanner\n\n";
        }

        return 0;
    }
}

1;