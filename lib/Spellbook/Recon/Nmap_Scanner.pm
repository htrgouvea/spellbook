package Spellbook::Recon::Nmap_Scanner {
    use strict;
    use warnings;
    use Nmap::Scanner; # https://metacpan.org/pod/Nmap::Scanner
    
    sub scan_started {
        my $self     = shift;
        my $host     = shift;
    
        my $hostname = $host -> hostname();
        my $addresses = join(',', map {$_ -> addr()} $host -> addresses());
        my $status = $host -> status();
    
        print "$hostname ($addresses) is $status\n";

        return 0;
    }
    
    sub port_found {
        my $self     = shift;
        my $host     = shift;
        my $port     = shift;
    
        my $name = $host->hostname();
        my $addresses = join(',', map {$_ -> addr()} $host -> addresses());
    
        print "On host $name ($addresses), found ",
            $port->state()," port ",
            join('/', $port -> protocol(), $port -> portid()), "\n";

        return 0;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $command, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=s" => \$target,
            "c|command=s" => \$command
        );

        if ($target) {
            my $scanner = Nmap::Scanner -> new();

            $scanner -> register_scan_started_event(\&scan_started);
            $scanner -> register_port_found_event(\&port_found);
            $scanner -> scan("-sS -p 1-1024 -O $target");
            
            my $results = $scanner -> scan();

            # print Dumper($results);

            return @result;
        } 

        if ($help) {
            return "
                \rRecon::Nmap_Scanner
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set an IP to run the scanner\n\n";
        }

        return 0;
    }
}

1;