package Spellbook::Parser::S3_Bucket {
    use strict;
    use warnings;
    use XML::Simple;
    use Spellbook::Core::UserAgent;
    use Try::Tiny;
    use Readonly;

    our $VERSION = '0.0.2';

    Readonly my $HTTP_OK => 200;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//msx) {
                $target = "https://$target";
            }

            if ($target !~ /\/$/msx) { $target .= '/'; }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $request   = $user_agent -> get($target);

            if ($request -> code() == $HTTP_OK) {
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

        if ($help || !$target) {
            return "
                \rParser::Bucket
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   S3 bucket URL or host (e.g. my-bucket.s3.amazonaws.com)\n\n";
        }

        return 0;
    }
}

1;
