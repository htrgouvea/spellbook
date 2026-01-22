package Spellbook::Helper::Host_Normalization {
    use strict;
    use warnings;
    use URI::URL;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ /^https?:\/\//x) {
                $target = "http://$target";
            }

            my $uri  = URI::URL -> new($target);
            my $host = $uri -> host();

            $host =~ s/^www\.//ix;
            $host =~ s/^\*.//x;

            return lc($host);
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
