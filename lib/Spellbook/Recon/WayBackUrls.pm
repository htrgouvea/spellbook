package Spellbook::Recon::WayBackUrls {
    use strict;
    use warnings;
    use JSON;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.2';

    use Readonly;

    Readonly my $HTTP_OK => 200;
    Readonly my $WAYBACK_TIMEOUT => 20;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target =~ /^http(?:s)?:\/\//msx) {
                $target =~ s/^http(?:s)?:\/\///msx;
            }

            $target =~ s/\/.*$//msx;

            my $endpoint  = "https://web.archive.org/cdx/search/cdx?url=$target/*&output=json&fl=original&collapse=urlkey";
            my $user_agent = Spellbook::Core::UserAgent -> new();
            
            $user_agent -> timeout($WAYBACK_TIMEOUT);
            
            my $request   = $user_agent -> get($endpoint);

            if (($request -> code() == $HTTP_OK) && ($request -> content ne '[]')) {
                my $content = decode_json($request -> content);

                foreach my $fullurl (@{$content}) {
                    if ($fullurl -> [0] ne 'original') {
                        push @result, $fullurl -> [0];
                    }
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
