package Spellbook::Recon::Get_Headers {
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
            my $ua = LWP::UserAgent -> new (
                ssl_opts => { verify_hostname => 0 }
            );

            my $response = $ua -> get($target);
            return $response -> headers_as_string, "\n";
        }

        if ($help) {
            return "
                \rRecon::Get_Headers
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set a URL to collect all headers\n\n";
        }

        return 0;
    }
}

1;