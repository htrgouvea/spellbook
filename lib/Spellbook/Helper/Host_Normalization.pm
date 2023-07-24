package Spellbook::Helper::Host_Normalization {
    use strict;
    use warnings;
    use URI::URL;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//) { 
                $target = "http://$target";
            }

            my $uri  = URI::URL -> new($target);
            my $host = $uri -> host();

            $host =~ s/^www\.//i;
            $host =~ s/^\*.//;

            return lc($host);

            # $target =~ s/^http(s)?:\/\///;
            # $target =~ s/\/$//;

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