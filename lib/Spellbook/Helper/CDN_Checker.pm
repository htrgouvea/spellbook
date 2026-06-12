package Spellbook::Helper::CDN_Checker {
    use strict;
    use warnings;
    use Net::IP;
    use Mojo::JSON;
    use Spellbook::Recon::Get_IP;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $type = 'cdn';

        Getopt::Long::GetOptionsFromArray (
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

            my $cdn_list = './files/cdn_list.json';
            my $load_list = Mojo::File -> new($cdn_list) -> slurp;

            if (!$load_list) {
                return @result;
            }

            my $data = Mojo::JSON::decode_json($load_list);
            my $content = $data -> {$type};
            my $value = Net::IP -> new($ip);

            if (!$content || !$value) {
                return @result;
            }

            foreach my $provider (keys %{$content}) {
                foreach my $cidr (@{$content -> {$provider}}) {
                    my $range = Net::IP -> new($cidr);

                    if (!$range) {
                        next;
                    }

                    my $match = $range -> overlaps($value);

                    if ($match) {
                        push @result, $target;
                    }
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
