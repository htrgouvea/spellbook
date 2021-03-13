package Spellbook::Recon::Shodan_Enum {
    use strict;
    use warnings;
    use JSON;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;

    sub new {
        my ($self, $ip) = @_;
        my @results = ();

        if ($ip) {
            my $apiKey    = Spellbook::Core::Credentials -> new("shodan");
            my $endpoint  = "https://api.shodan.io/shodan/host/$ip?key=$apiKey";
            my $userAgent = LWP::UserAgent -> new();
            my $request   = $userAgent -> get($endpoint);
            my $httpCode  = $request -> code();

            if ($httpCode == 200) {
                my $content = decode_json($request -> content);

                foreach my $data (@{$content -> {'data'}}) {
                    my $product   = $data -> {'product'} || "unknown";
                    my $port      = $data -> {'port'};
                    my $transport = $data -> {'transport'};
                    my $service   = $data -> {'_shodan'} -> {'module'};

                    push @results, "$ip | $transport | $port | $service | $product\n";
                }
            }
        }   

        return @results;
    }
}

1;