package Spellbook::Recon::Masscan {
    use strict;
    use warnings;
    use Getopt::Long;
    use Masscan::Client;
    use List::MoreUtils qw(uniq);
    use Spellbook::Recon::Get_IP;
    use Spellbook::Helper::CDN_Checker;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, @target, @ports, @result, $skip_cdn);

        my @arguments = qw(--rate 500 --wait 10 --retries 5 -e en0 --router-mac 3c:64:cf:6c:53:78 --adapter-ip 192.168.68.107);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'        => \$help,
            't|target=s'    => \@target,
            'p|port=s'      => \@ports,
            'a|arguments=s' => \@arguments,
            'skip-cdn'      => \$skip_cdn
        );

        if (@target) {
            if (!@ports) {
                @ports = '1-65535';
            }

            if ($skip_cdn) {
                my $cdn_checker = Spellbook::Helper::CDN_Checker -> new (['--target' => $target[0]]);

                if ($cdn_checker) {
                    return 0;
                }
            }

            my @ip = Spellbook::Recon::Get_IP -> new(['--target' => $target[0]]);

            my $masscan = Masscan::Client -> new (
                hosts     => \@ip,
                ports     => \@ports,
                arguments => \@arguments
            );

            my $scan = $masscan -> scan();

            if ($scan) {
                my $result = $masscan -> scan_results();

                foreach my $value (@{$result -> {'scan_results'}}) {
                    push @result, $target[0] . q{:} . $value -> {'ports'} -> [0] -> {'port'};
                }

                return uniq @result;
            }
        }

        if ($help) {
            return "\n"
                . "Recon::Masscan\n"
                . "=====================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     Set an Domain/IP to make a port scanning using masscan\n"
                . "-p, --ports      Define ports to scan\n"
                . "-a, --arguments  Parameters to masscanner\n"
                . "--skip-cdn       Skip the CDN check\n\n";
        }

        return 0;
    }
}

1;
