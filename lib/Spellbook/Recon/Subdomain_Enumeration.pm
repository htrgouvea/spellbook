package Spellbook::Recon::Subdomain_Enumeration {
    use strict;
    use warnings;
    use JSON;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;
    
    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            my $apiKey    = Spellbook::Core::Credentials -> new(["--platform" => "security-trails"]);
            my $endpoint  = "https://api.securitytrails.com/v1/domain/$target/subdomains?children_only=false&include_inactive=true";
            my $userAgent = LWP::UserAgent -> new(ssl_opts => { verify_hostname => 0 });
            my $request   = $userAgent -> get($endpoint, "apikey" => $apiKey);
            my $httpCode  = $request -> code();

            if ($httpCode == 200) {
                my $content = decode_json($request -> content);
                
                foreach my $subdomain (@{$content -> {"subdomains"}}) {
                    push @result, "$subdomain.$target";
                }
            }

            return @result;
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