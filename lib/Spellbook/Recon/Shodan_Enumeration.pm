package Spellbook::Recon::Shodan_Enumeration {
    use strict;
    use warnings;
    use JSON;
    use Spellbook::Core::UserAgent;
    use Spellbook::Recon::Get_IP;
    use Spellbook::Core::Credentials;
    use Data::Validate::Domain qw(is_domain);

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target =~ /^http(s)?:\/\//x) {
                $target =~ s/^http(s)?:\/\///x;
            }

            my $validate = is_domain($target);

            if ($validate) {
                my $ip = Spellbook::Recon::Get_IP -> new (['--target' => $target]);

                my $apiKey    = Spellbook::Core::Credentials -> new(['--platform' => 'shodan']);
                my $endpoint  = "https://api.shodan.io/shodan/host/$ip?key=$apiKey";
                my $userAgent = Spellbook::Core::UserAgent -> new();
                my $request   = $userAgent -> get($endpoint);
                my $httpCode  = $request -> code();

                if ($httpCode == 200) {
                    my $content = decode_json($request -> content);

                    foreach my $data (@{$content -> {'data'}}) {
                        my $port      = $data -> {'port'};

                        push @result, "$target:$port";
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
