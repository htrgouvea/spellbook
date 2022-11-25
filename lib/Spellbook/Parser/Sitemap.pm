package Spellbook::Parser::Sitemap {
    use strict;
    use warnings;
    use LWP::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//) { $target = "https://$target"; }
            if ($target !~ /\/sitemap.xml$/) { $target = "$target/sitemap.xml"; }

            my $userAgent = LWP::UserAgent -> new(
                agent => "Spellbook",
                ssl_opts => { verify_hostname => 0 }
            );

            my $request = $userAgent -> get($target);

            if ($request -> code() == 200) {
                my $content = $request -> content();

                while ($content =~ m/<loc>(.*?)<\/loc>/g) {
                    push @result, $1;
                }
            }
        
            return @result;
        }

        if ($help) {
            return "
                \rParser::Sitemap
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   \n\n";
        }

        return 0;
    }
}

1;