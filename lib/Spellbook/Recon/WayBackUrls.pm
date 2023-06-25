package Spellbook::Recon::WayBackUrls {
    use strict;
    use warnings;
    use JSON;
    use LWP::UserAgent;
    use Mojo::URL;
    use Data::Dumper;
    
    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            sleep(1);
            
            my $endpoint  = "http://web.archive.org/cdx/search/cdx?url=$target/*&output=json&collapse=urlkey";
            my $userAgent = LWP::UserAgent -> new();
            my $request   = $userAgent -> get($endpoint);
            
            if (($request -> code() == 200) && ($request -> content ne '[]')) {
                my $content = decode_json($request -> content);

                foreach my $fullurl (@{$content}) {
                    push @result, $fullurl -> [2];
                }
            }
            
            return @result;
        }

        if ($help) {
            return "
                \rRecon::WaybackUrls
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Set an website to see paths from WayBackMachine\n";
        }

        return 0;
    }
}

1;