package Spellbook::Recon::Query_Shodan {
    use strict;
    use warnings;
    use JSON;
    use Spellbook::Core::UserAgent;
    use Spellbook::Core::Credentials;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $query, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'    => \$help,
            'q|query=s' => \$query
        );

        if ($query) {
            my $apiKey    = Spellbook::Core::Credentials -> new(['--platform' => 'shodan']);
            my $endpoint  = "https://api.shodan.io/shodan/host/search?key=$apiKey&query=$query&limit=300";
            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $request   = $userAgent -> get($endpoint);
            my $httpCode  = $request -> code();

            if ($httpCode == 200) {
                my $content = decode_json($request -> content());

                foreach my $data (@{$content -> {'matches'}}) {
                    my $hostname = $data -> {'ip_str'};
                    my $port = $data -> {'port'};

                    push @result, "$hostname:$port";
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Shodan
                \r=====================
                \r-h, --help     See this menu
                \r-t, --query    Define a query\n\n";
        }

        return 0;
    }
}

1;