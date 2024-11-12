package Spellbook::Platform::HackerOne {
    use strict;
    use warnings;
    use JSON;
    use MIME::Base64;
    use Spellbook::Core::UserAgent;
    use Spellbook::Core::Credentials;
    use Spellbook::Helper::Host_Normalization;

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
            my $useragent = Spellbook::Core::UserAgent -> new();
            my $api_url   = "https://api.hackerone.com/v1/hackers/programs/$target";

            my $response = $useragent -> get ($api_url,
                "Content-Type"  => "application/json",
                "Authorization" => "Basic " . encode_base64($token)
            );

            if ($response -> is_success()) {
                my $data     = decode_json($response -> decoded_content());
                my $programs = $data -> {"data"};

                for my $scope (@{$data -> {"relationships"} -> {"structured_scopes"} -> {"data"}}) {
                    if (($scope -> {"attributes"} -> {"asset_type"} eq "URL") && ($scope -> {"attributes"} -> {"eligible_for_bounty"})) {
                        my $url = $scope -> {"attributes"} -> {"asset_identifier"};

                        push @result, Spellbook::Helper::Host_Normalization -> new(["--target" => $url]);
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return<<"EOT";

Platform::HackerOne
=====================
-h, --help     See this menu
-t, --target   Program handle from HackerOne\n\n";

EOT
        }

        return 0;
    }
}

1;