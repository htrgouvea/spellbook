package Spellbook::Advisory::CVE_2022_1595 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;
    use Readonly;

    our $VERSION = '0.0.1';

    Readonly my $HTTP_MOVED_PERMANENTLY => 301;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ /^https?:\/\//xsm) {
                $target = "https://$target";
            }

            my $useragent = Spellbook::Core::UserAgent -> new();
            my $request = $useragent -> get ($target, 'Cookie' => 'valid_login_slug=1');

            if ($request -> code() == $HTTP_MOVED_PERMANENTLY) {
                push @result, $request -> header('Location');
            }

            return @result;
        }

        if ($help) {
            return
                "\n"
              . "                \rAdvisory::CVE_2022_1595\n"
              . "                \r=======================\n"
              . "                \r-h, --help     See this menu\n"
              . "                \r-t, --target   Define a target\n\n\n";
        }

        return 0;
    }
}

1;
