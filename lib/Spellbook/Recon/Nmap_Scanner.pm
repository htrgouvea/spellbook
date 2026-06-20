package Spellbook::Recon::Nmap_Scanner {
    use strict;
    use warnings;
    use Nmap::Scanner;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $ports, @result);

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'p|ports=s'  => \$ports,
        );

        if ($target) {
            if (!$ports) {
                $ports = '1-1024';
            }

            my $scanner = Nmap::Scanner->new();

            $scanner->register_port_found_event(sub {
                my ($nmap_obj, $host, $port) = @_;

                if ($port->state() eq 'open') {
                    push @result, $target . q{:} . $port->portid();
                }
            });

            $scanner->scan("-p $ports $target");

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Nmap_Scanner\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Set an IP/domain to run the scanner\n"
                . "-p, --ports    Define ports to scan (default: 1-1024)\n\n";
        }

        return 0;
    }
}

1;
