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

        my $type = 'cdn'; # waf, cloud, cdn, common

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'T|type=s'   => \$type
        );

        if ($target) {
            my $ip = Spellbook::Recon::Get_IP -> new(['--target' => $target]);

            if ($ip) {
                my $cnd_list  = './files/cdn_list.json';
                my $load_list = Mojo::File -> new($cnd_list) -> slurp;

                if ($load_list) {
                    my $data = Mojo::JSON::decode_json($load_list);
                    my $content = $data -> {$type};

                    for (keys %{$content}) {
                        for (@{$content -> {$_}}) {
                            my $range = Net::IP -> new($_);
                            my $value = Net::IP -> new($ip);
                            my $match =  $range -> overlaps($value);

                            if ($match) {
                                push @result, $target;
                            }
                        }
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rHelper::CDN_Checker
                \r=====================
                \r-h, --help     See this menu
                \r-t --target    Define a target
                \r-T, --type     \n\n";
        }

        return 0;
    }
}

1;