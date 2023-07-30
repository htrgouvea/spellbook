package Spellbook::Recon::Subdomain_Enumeration {
    use strict;
    use warnings;
    use JSON;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;
    use Spellbook::Core::Credentials;
    
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

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $apiKey    = Spellbook::Core::Credentials -> new(["--platform" => "security-trails"]);

            my @endpoints = (
                "https://api.securitytrails.com/v1/domain/$target/subdomains?children_only=false&include_inactive=true",
                "https://prod-otxp-web.otx.alienvault.io/otxapi/indicators/domain/passive_dns/$target"
            );

            foreach my $endpoint (@endpoints) {
                my $request = $userAgent -> get($endpoint, "apikey" => $apiKey);

                if ($request -> code() == 200) {
                    my $content = decode_json($request -> content);
                    
                    if ($content -> {"subdomains"}) {
                        foreach my $subdomain (@{$content -> {"subdomains"}}) {
                            push @result, "$subdomain.$target";
                        }
                    }
                    
                    if ($content -> {"passive_dns"}) {
                        foreach my $value (@{$content -> {"passive_dns"}}) {
                            push @result, $value -> {"hostname"};
                        }
                    }
                }
            }

            return uniq @result;
        } 

        if ($help) {
            return "
                \rRecon::Subdomain_Enumeration
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Find subdomains from a target using SecurityTrails\n\n";
        }

        return 0;
    }
}

1;