package Spellbook::Recon::Wildcard_Detection {
    use strict;
    use warnings;
    use Net::DNS;
    use Spellbook::Helper::Generate_UUID;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $DEFAULT_SAMPLES => 5;

    sub _extract_fingerprint {
        my ($packet) = @_;
        my @records;

        foreach my $record ($packet -> answer()) {
            push @records, $record -> type() . q{:} . $record -> rdstring();
        }

        if (!@records) {
            return 0;
        }

        my @sorted = sort @records;
        return join q{,}, @sorted;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);
        my $samples = $DEFAULT_SAMPLES;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'      => \$help,
            't|target=s'  => \$target,
            's|samples=i' => \$samples
        );

        if ($target) {
            if ($target =~ /^http(s)?:\/\//msx) {
                $target =~ s/^http(s)?:\/\///msx;
            }

            my @uuids = Spellbook::Helper::Generate_UUID
                -> new(['--version' => 4, '--repeat' => $samples]);
            my $resolver = Net::DNS::Resolver -> new();
            my $resolved_samples = 0;

            foreach my $uuid (@uuids) {
                my $candidate = "$uuid.$target";
                my $response = $resolver -> search($candidate);

                if ($response) {
                    my $fingerprint = _extract_fingerprint($response);

                    if ($fingerprint) {
                        $resolved_samples++;
                    }
                }
            }

            if ($resolved_samples > 0) {
                return $target;
            }

            return 0;
        }

        if ($help) {
            return "\n"
                . "Recon::Wildcard_Detection\n"
                . "=========================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     Set a domain as a target\n"
                . "-s, --samples    Number of random UUID v4 probes\n\n";
        }

        return 0;
    }
}

1;
