package Spellbook::Recon::Shodan_Enumeration {
    use strict;
    use warnings;
    use JSON;
    use Spellbook::Core::UserAgent;
    use Spellbook::Recon::Get_IP;
    use Spellbook::Core::Credentials;
    use Data::Validate::Domain qw(is_domain);

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK => 200;

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

            if (!is_domain($target)) {
                return @result;
            }

            my $ip = Spellbook::Recon::Get_IP -> new (['--target' => $target]);

            if (!$ip) {
                return @result;
            }

            my $api_key    = Spellbook::Core::Credentials -> new(['--platform' => 'shodan']);
            my $endpoint   = "https://api.shodan.io/shodan/host/$ip?key=$api_key";
            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $request    = $user_agent -> get($endpoint);
            my $http_code  = $request -> code();

            if ($http_code == $HTTP_OK) {
                my $content = decode_json($request -> content);

                foreach my $data (@{$content -> {'data'}}) {
                    my $port      = $data -> {'port'};
                    my $transport = $data -> {'transport'} || 'tcp';
                    my $line      = "$target:$port/$transport";

                    my $product = $data -> {'product'};
                    my $version = $data -> {'version'};

                    if (defined $product && length $product) {
                        $line .= " $product";
                    }

                    if (defined $version && length $version) {
                        $line .= " $version";
                    }

                    if (ref $data -> {'vulns'} eq 'HASH') {
                        my @cves = sort keys %{ $data -> {'vulns'} };
                        $line .= ' [' . join(', ', @cves) . ']';
                    }

                    push @result, $line;
                }
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Shodan_Enum\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Set a domain to enumerate ports, services and CVEs via the Shodan API\n\n";
        }

        return 0;
    }
}

1;
