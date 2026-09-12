package Spellbook::Helper::CDN_Checker {
    use strict;
    use warnings;
    use Getopt::Long;
    use Net::IP;
    use Mojo::File;
    use Mojo::JSON;
    use Spellbook::Recon::Get_IP;

    our $VERSION = '0.0.2';

    my %RANGES;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $type = 'cdn';

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'T|type=s'   => \$type
        );

        if ($target) {
            my $ip = Spellbook::Recon::Get_IP -> new(['--target' => $target]);

            if (!$ip) {
                return @result;
            }

            # The CDN list (~191 KB) and its CIDRs are invariant across targets,
            # so parse the JSON and build the Net::IP range objects once per
            # type and reuse them. Previously every target re-slurped the file
            # and rebuilt ~11k Net::IP objects.
            if (!exists $RANGES{$type}) {
                my $cdn_list  = './files/cdn_list.json';
                my $load_list = Mojo::File -> new($cdn_list) -> slurp;

                if (!$load_list) {
                    return @result;
                }

                my $data    = Mojo::JSON::decode_json($load_list);
                my $content = $data -> {$type};

                my @ranges;

                if ($content) {
                    foreach my $provider (keys %{$content}) {
                        foreach my $cidr (@{$content -> {$provider}}) {
                            my $range = Net::IP -> new($cidr);

                            if ($range) {
                                push @ranges, $range;
                            }
                        }
                    }
                }

                $RANGES{$type} = \@ranges;
            }

            my $value = Net::IP -> new($ip);

            if (!@{$RANGES{$type}} || !$value) {
                return @result;
            }

            foreach my $range (@{$RANGES{$type}}) {
                my $match = $range -> overlaps($value);

                if ($match) {
                    push @result, $target;
                }
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Helper::CDN_Checker\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t --target    Define a target\n"
                . "-T, --type     \n\n";
        }

        return 0;
    }
}

1;
