package Spellbook::Helper::CDN_Checker {
    use strict;
    use warnings;
    use JSON;
    use Net::IP;
    use Spellbook::Core::UserAgent;
    use Spellbook::Recon::Get_IP;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            my $ip = Spellbook::Recon::Get_IP -> new (["--target" => $target]);

            if ($ip) {
                my $cnd_list  = "https://raw.githubusercontent.com/projectdiscovery/cdncheck/main/cmd/generate-index/sources_data.json";
                my $useragent = Spellbook::Core::UserAgent -> new ();
                my $request   = $useragent -> get($cnd_list);

                if ($request -> code == 200) {
                    my $data    = decode_json($request -> content);
                    my $content = $data -> {"cdn"};

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
                \r-t --target    Define a target\n\n";
        }

        return 0;
    }
}

1;