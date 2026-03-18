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
            if ($target =~ /^http(s)?:\/\//msx) {
                $target =~ s/^http(s)?:\/\///msx;
            }

            my $validate = is_domain($target);

            if ($validate) {
                my $ip = Spellbook::Recon::Get_IP -> new (['--target' => $target]);

                my $api_key    = Spellbook::Core::Credentials -> new(['--platform' => 'shodan']);
                my $endpoint  = "https://api.shodan.io/shodan/host/$ip?key=$api_key";
                my $user_agent = Spellbook::Core::UserAgent -> new();
                my $request   = $user_agent -> get($endpoint);
                my $http_code  = $request -> code();

                if ($http_code == 200) {
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
