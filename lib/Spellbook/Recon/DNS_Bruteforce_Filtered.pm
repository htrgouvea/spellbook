package Spellbook::Recon::DNS_Bruteforce_Filtered {
    use strict;
    use warnings;
    use Net::DNS;
    use Spellbook::Helper::Generate_UUID;

    our $VERSION = '0.0.1';

    sub _extract_fingerprint {
        my ($packet) = @_;
        my @records;

        foreach my $resource_record ($packet -> answer()) {
            push @records, $resource_record -> type() . ':' . $resource_record -> rdstring();
        }

        if (!@records) {
            return 0;
        }

        my @sorted = sort @records;
        return join ',', @sorted;
    }

    sub _extract_record_values {
        my ($packet) = @_;
        my %values = (
            A     => {},
            AAAA  => {},
            CNAME => {}
        );

        foreach my $resource_record ($packet -> answer()) {
            my $type = $resource_record -> type();

            if ($type eq 'A') {
                my $value = $resource_record -> rdstring();
                $values{A}->{$value} = 1;
            }

            if ($type eq 'AAAA') {
                my $value = $resource_record -> rdstring();
                $values{AAAA}->{$value} = 1;
            }

            if ($type eq 'CNAME') {
                my $value = $resource_record -> rdstring();
                $values{CNAME}->{$value} = 1;
            }
        }

        return %values;
    }

    sub _build_wildcard_profile {
        my ($target, $samples) = @_;
        my @uuids = Spellbook::Helper::Generate_UUID
            -> new(['--version' => 4, '--repeat' => $samples]);
        my $resolver = Net::DNS::Resolver -> new();
        my %fingerprints;
        my %values = (
            A     => {},
            AAAA  => {},
            CNAME => {}
        );

        foreach my $uuid (@uuids) {
            my $candidate = "$uuid.$target";
            my $response = $resolver -> search($candidate);

            if ($response) {
                my $fingerprint = _extract_fingerprint($response);
                my %response_values = _extract_record_values($response);

                if ($fingerprint) {
                    $fingerprints{$fingerprint} = 1;
                }

                foreach my $value (keys %{$response_values{A}}) {
                    $values{A}->{$value} = 1;
                }

                foreach my $value (keys %{$response_values{AAAA}}) {
                    $values{AAAA}->{$value} = 1;
                }

                foreach my $value (keys %{$response_values{CNAME}}) {
                    $values{CNAME}->{$value} = 1;
                }
            }
        }

        my $active = 0;

        if (keys %fingerprints) {
            $active = 1;
        }

        return (
            active       => $active,
            fingerprints => \%fingerprints,
            values       => \%values
        );
    }

    sub _is_baseline_match {
        my ($packet, $profile) = @_;
        my $fingerprint = _extract_fingerprint($packet);

        if ($fingerprint && exists $profile->{fingerprints}->{$fingerprint}) {
            return 1;
        }

        my %response_values = _extract_record_values($packet);
        my $has_values = 0;
        my $has_outside = 0;

        foreach my $value (keys %{$response_values{A}}) {
            $has_values = 1;

            if (!exists $profile->{values}->{A}->{$value}) {
                $has_outside = 1;
            }
        }

        foreach my $value (keys %{$response_values{AAAA}}) {
            $has_values = 1;

            if (!exists $profile->{values}->{AAAA}->{$value}) {
                $has_outside = 1;
            }
        }

        foreach my $value (keys %{$response_values{CNAME}}) {
            $has_values = 1;

            if (!exists $profile->{values}->{CNAME}->{$value}) {
                $has_outside = 1;
            }
        }

        if ($has_values && !$has_outside) {
            return 1;
        }

        return 0;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $mode, @result);
        my $wordlist = './files/subdomains.txt';
        my $samples = 5;
        $mode = 'best_effort';

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'      => \$help,
            't|target=s'  => \$target,
            'f|file=s'    => \$wordlist,
            's|samples=i' => \$samples,
            'm|mode=s'    => \$mode
        );

        if ($target && $wordlist) {
            if ($target =~ /^http(s)?:\/\//msx) {
                $target =~ s/^http(s)?:\/\///msx;
            }

            my @file;
            open my $handle, '<', $wordlist or return 0;
            while (defined(my $line = <$handle>)) {
                chomp $line;

                if (length $line) {
                    push @file, $line;
                }
            }
            close $handle;
            my %profile = _build_wildcard_profile($target, $samples);
            my $wildcard_active = $profile{active};

            if ($mode eq 'strict' && $wildcard_active) {
                return 0;
            }

            if ($mode ne 'strict' && $mode ne 'best_effort') {
                return 0;
            }

            if (@file) {
                my $resolver = Net::DNS::Resolver -> new();

                foreach my $line (@file) {
                    my $candidate = "$line.$target";
                    my $response = $resolver -> search($candidate);

                    if ($response) {
                        my $fingerprint = _extract_fingerprint($response);

                        if ($fingerprint) {
                            if ($mode eq 'best_effort' && $wildcard_active) {
                                my $baseline_match = _is_baseline_match(
                                    $response,
                                    \%profile
                                );

                                if (!$baseline_match) {
                                    push @result, $candidate;
                                }
                            }

                            if ($mode eq 'strict') {
                                push @result, $candidate;
                            }

                            if ($mode eq 'best_effort' && !$wildcard_active) {
                                push @result, $candidate;
                            }
                        }
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::DNS_Bruteforce_Filtered
                \r==============================
                \r-h, --help       See this menu
                \r-t, --target     Set a domain as a target
                \r-f, --file       Define a wordlist
                \r-s, --samples    Number of wildcard probes
                \r-m, --mode       strict or best_effort (default: best_effort)\n\n";
        }

        return 0;
    }
}

1;
