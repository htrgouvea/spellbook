package Spellbook::Recon::Query_Shodan {
    use strict;
    use warnings;
    use JSON;
    use Spellbook::Core::UserAgent;
    use Spellbook::Core::Credentials;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK => 200;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $query, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'    => \$help,
            'q|query=s' => \$query
        );

        if ($query) {
            my $api_key    = Spellbook::Core::Credentials -> new(['--platform' => 'shodan']);
            my $endpoint  = "https://api.shodan.io/shodan/host/search?key=$api_key&query=$query&limit=300";
            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $request   = $user_agent -> get($endpoint);
            my $http_code  = $request -> code();

            if ($http_code == $HTTP_OK) {
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
            return "\n"
                . "Recon::Shodan\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --query    Define a query\n\n";
        }

        return 0;
    }
}

1;