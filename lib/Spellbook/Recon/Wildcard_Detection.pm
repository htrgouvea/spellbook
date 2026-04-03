package Spellbook::Recon::Wildcard_Detection {
    use strict;
    use warnings;
    use Net::DNS;
    use Spellbook::Helper::Generate_UUID;

    our $VERSION = '0.0.1';

    sub _extract_fingerprint {
        my ($packet) = @_;
        my @records;

        foreach my $record ($packet -> answer()) {
            push @records, $record -> type() . ':' . $record -> rdstring();
        }

        if (!@records) {
            return 0;
        }

        my @sorted = sort @records;
        return join ',', @sorted;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);
        my $samples = 5;

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
            return "
                \rRecon::Wildcard_Detection
                \r=========================
                \r-h, --help       See this menu
                \r-t, --target     Set a domain as a target
                \r-s, --samples    Number of random UUID v4 probes\n\n";
        }

        return 0;
    }
}

1;
