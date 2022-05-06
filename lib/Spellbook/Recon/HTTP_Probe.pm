package Spellbook::Recon::HTTP_Probe {
    use strict;
    use warnings;
    use LWP::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=s" => \$target
        );
    
        if ($target) {
            my $userAgent = LWP::UserAgent -> new (ssl_opts => { verify_hostname => 0 });
            my $response = $userAgent -> get($target);

            if ($response) { return $target; }
        }

        if ($help) {
            return "
                \rRecon::HTTP_Probe
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Define a target to make a HTTP request probe\n\n";
        }

        return 0;
    }
}

1;