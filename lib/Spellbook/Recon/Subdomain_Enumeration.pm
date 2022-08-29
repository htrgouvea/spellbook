package Spellbook::Recon::Subdomain_Enumeration {
    use strict;
    use warnings;
    use JSON;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;
    use List::MoreUtils qw(uniq);
    
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

            my $userAgent = LWP::UserAgent -> new(ssl_opts => { verify_hostname => 0 });
            my $apiKey    = Spellbook::Core::Credentials -> new(["--platform" => "security-trails"]);

            my $st_endpoint  = "https://api.securitytrails.com/v1/domain/$target/subdomains?children_only=false&include_inactive=true";
            my $otx_endpoint = "https://prod-otxp-web.otx.alienvault.io/otxapi/indicators/domain/passive_dns/$target";
            
            my $request = $userAgent -> get($st_endpoint, "apikey" => $apiKey);

            if ($request -> code() == 200) {
                my $content = decode_json($request -> content);
                
                foreach my $subdomain (@{$content -> {"subdomains"}}) {
                    push @result, "$subdomain.$target";
                }
            }

            $request   = $userAgent -> get ($otx_endpoint);

            if ($request -> code() == 200) {
                my $data = decode_json($request -> content());

                foreach my $value (@{$data -> {"passive_dns"}}) {
                    push @result, $value -> {"hostname"};
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