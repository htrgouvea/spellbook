package Spellbook::Helper::Host_Normalization {
    use strict;
    use warnings;
    use URI::URL;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//x) { 
                $target = "http://$target";
            }

            my $uri  = URI::URL -> new($target);
            my $host = $uri -> host();

            $host =~ s/^www\.//ix;
            $host =~ s/^\*.//x;

            return lc($host);

            # $target =~ s/^http(s)?:\/\///;
            # $target =~ s/\/$//;
            # the main idea of this module is to apply some filter in odd URLs from scopes of BB platforms for example

            # return $target;
        }

        if ($help) {
            return "
                \rHelper::Host_Normalization
                \r==========================
                \r-h, --help     See this menu
                \r-t, --target   Define a target to normalize\n\n";
        }

        return 0;
    }
}

1;