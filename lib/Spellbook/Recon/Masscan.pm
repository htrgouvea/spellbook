package Spellbook::Recon::Masscan {
    use strict;
    use warnings;
    use Masscan::Scanner;
    use List::MoreUtils qw(uniq);
    use Spellbook::Recon::Get_IP;
    use Spellbook::Helper::CDN_Checker;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, @target, @ports, @result, $skip_cdn);

        my @arguments = qw(--banners);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"      => \$help,
            "t|target=s"  => \@target,
            "p|port=s"    => \@ports,
            "a|arguments" => \@arguments,
            "skip-cdn"    => \$skip_cdn
        );

        if (@target) {
            if (!@ports) { @ports = "1-65535"; }

            if ($skip_cdn) {
                my $CDN_Checker = Spellbook::Helper::CDN_Checker -> new (["--target" => $target[0]]);

                if ($CDN_Checker) {
                    return 0;
                }
            }

            my @ip = Spellbook::Recon::Get_IP -> new(["--target" => $target[0]]);

            my $masscan = Masscan::Scanner -> new (
                hosts     => \@ip,
                ports     => \@ports,
                arguments => \@arguments
            );

            my $scan = $masscan -> scan();

            if ($scan) {
                my $result = $masscan -> scan_results();

                foreach my $value (@{$result -> {"scan_results"}}) {
                    push @result, $target[0] . ":" . $value -> {"ports"} -> [0] -> {"port"};
                }

                return uniq @result;
            }
        }

        if ($help) {
            return<<"EOT";

Recon::Masscan
=====================
-h, --help       See this menu
-t, --target     Set an Domain/IP to make a port scanning using masscan
-p, --ports      Define ports to scan
-a, --arguments  Parameters to masscanner
--skip-cdn       Skip the CDN check\n\n";

EOT
        }

        return 0;
    }
}

1;