package Spellbook::Recon::Shodan_Enumeration {
    use strict;
    use warnings;
    use JSON;
    use LWP::UserAgent;
    use Spellbook::Recon::Get_IP;
    use Spellbook::Recon::Host_Resolv;
    use Spellbook::Core::Credentials;
    use Data::Validate::Domain qw(is_domain);

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target =~ /^http(s)?:\/\//) {
                $target =~ s/^http(s)?:\/\///;
            }
            
            my $validate = is_domain($target);

            if ($validate) {
                my $ip = Spellbook::Recon::Get_IP -> new (["--target" => $target]);

                my $apiKey    = Spellbook::Core::Credentials -> new(["--platform" => "shodan"]);
                my $endpoint  = "https://api.shodan.io/shodan/host/$ip?key=$apiKey";
                my $userAgent = LWP::UserAgent -> new(ssl_opts => { verify_hostname => 0 });
                my $request   = $userAgent -> get($endpoint);
                my $httpCode  = $request -> code();

                if ($httpCode == 200) {
                    my $content = decode_json($request -> content);

                    foreach my $data (@{$content -> {"data"}}) {
                        my $product   = $data -> {"product"} || "unknow";
                        my $port      = $data -> {"port"};
                        my $transport = $data -> {"transport"};
                        my $service   = $data -> {"_shodan"} -> {"module"};
                        my @cves      = {};

                        if ($data -> {"vulns"}) {
                            for (keys %{$data -> {"vulns"}}) {
                                push @cves, $_;
                            }

                            push @result, "$transport://$target:$port | $service | $product | @cves";
                        }

                        else {
                            push @result, "$transport://$target:$port | $service | $product";
                        }
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Shodan_Enum
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set an IP to see infos on shodan API\n\n";
        }

        return 0;
    }
}

1;