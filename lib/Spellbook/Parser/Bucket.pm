package Spellbook::Parser::Bucket {
    use strict;
    use warnings;
    use XML::Simple;
    use LWP::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
        );

        if ($target) {
            my $userAgent = LWP::UserAgent -> new(ssl_opts => { verify_hostname => 0 });
            my $request   = $userAgent -> get($target);

            if ($request -> code() == 200) {
                my $xml  = XML::Simple -> new();
                my $content = $xml -> XMLin($request -> content());

                foreach my $element (@{$content -> {Contents}}) {
                    push @result, $element -> {Key};
                }
            }
        
            return @result;
        }

        if ($help) {
            return "
                \rParser::Bucket
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   \n\n";
        }

        return 0;
    }
}

1;