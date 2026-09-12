package Spellbook::Advisory::CVE_2026_42589 {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Core::UserAgent;
    use Readonly;

    our $VERSION = '0.0.1';

    Readonly my $HTTP_OK => 200;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $payload, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'target=s'  => \$target,
            'payload=s' => \$payload,
            'help'      => \$help
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//msx) {
                $target = "https://$target";
            }


        }


        if ($help) {
            return
                "\n"
              . "\rAdvisory::CVE_2026\n"
              . "\r=======================\n"
              . "\r-h, --help     See this menu\n"
              . "\r-t, --target   Define a target\n\n\n";
        }
    }
}

1;
