package Spellbook::Parser::Sitemap {
    use strict;
    use warnings;
    use URI;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//x) { $target = "https://$target"; }
            if ($target !~ /\/sitemap.xml$/x) { $target = "$target/sitemap.xml"; }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $request = $userAgent -> get($target);

            if ($request -> code() == 200) {
                my $content = $request -> content();

                while ($content =~ m/<loc>(.*?)<\/loc>/gx) {
                    my $url = URI -> new($1);
                    $target = URI -> new($target);

                    if ($url -> host() eq $target -> host()) {
                        push @result, $1;
                    }
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