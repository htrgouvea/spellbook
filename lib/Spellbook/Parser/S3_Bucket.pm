package Spellbook::Parser::S3_Bucket {
    use strict;
    use warnings;
    use XML::Simple;
    use Spellbook::Core::UserAgent;
    use Try::Tiny;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//x) {
                $target = "https://$target";    
            }
            
            if ($target !~ /\/$/x) { $target .= "/"; }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $request   = $userAgent -> get($target);

            if ($request -> code() == 200) {
                try {
                    my $xml = XML::Simple -> new();
                    my $content = $xml -> XMLin($request -> content());

                    foreach my $element (@{$content -> {Contents}}) {
                        push @result, $target . $element -> {Key};
                    }
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