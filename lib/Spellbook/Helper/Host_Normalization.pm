package Spellbook::Helper::Host_Normalization {
    use strict;
    use warnings;
    use Getopt::Long;
    use URI::URL;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ /^https?:\/\//msx) {
                $target = "http://$target";
            }

            my $uri  = URI::URL -> new($target);
            my $host = $uri -> host();

            $host =~ s/^www[.]//imsx;
            $host =~ s/^[*][.]//msx;

            return lc $host;
        }

        if ($help) {
            return
                "Helper::Host_Normalization\n" .
                "==========================\n" .
                "-h, --help     See this menu\n" .
                "-t, --target   Define a target to normalize\n\n";
        }

        return 0;
    }
}

1;
