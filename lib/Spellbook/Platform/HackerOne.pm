package Spellbook::Platform::HackerOne {
    use strict;
    use warnings;
    use JSON;
    use MIME::Base64;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;
    use Try::Tiny;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        my $token = Spellbook::Core::Credentials -> new(["--platform" => "hackerone"]);
        
        if ($token && $target) {
            my $useragent = LWP::UserAgent -> new();
            my $api_url   = "https://api.hackerone.com/v1/hackers/programs/$target";

            my $response = $useragent -> get ($api_url,
                "Content-Type"  => "application/json",
                "Authorization" => "Basic " . encode_base64($token)
            );


            if ($response -> is_success()) {
                my $data     = decode_json($response -> decoded_content());
                my $programs = $data -> {"data"};

                for my $scope (@{$data -> {"relationships"} -> {"structured_scopes"} -> {"data"}}) {
                    if ($scope -> {"attributes"} -> {"asset_type"} eq "URL") {
                        my $url = $scope -> {"attributes"} -> {"asset_identifier"};

                        if ($url =~ m/^\*./) {
                            $url =~ s/^\*.//;
                        }

                        push @result, $url;
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rPlatform::HackerOne
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Program ID from HackerOne\n\n";
        }

        return 0;
    }
}   

1;