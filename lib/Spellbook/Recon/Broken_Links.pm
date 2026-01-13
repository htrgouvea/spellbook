package Spellbook::Recon::Broken_Links {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;
    use URI;
    use WWW::Mechanize;

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
            if ($target !~ m{^https?://}ixsm) {
                $target = "https://$target";
            }

            my $mech = WWW::Mechanize -> new (
                autocheck => 0,
                ssl_opts => { verify_hostname => 0 }
            );

            $mech -> get($target);

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $base = URI -> new($target);
            my @links = $mech -> links();
            my %seen;

            for my $link (@links) {
                my $url = $link -> url();

                if (!$url) {
                    next;
                }

                if ($url =~ m{^mailto:}ixsm) {
                    next;
                }

                if ($url =~ m{^javascript:}ixsm) {
                    next;
                }

                my $absoluteUrl = URI -> new_abs($url, $base) -> as_string();

                if ($seen{$absoluteUrl}) {
                    next;
                }

                $seen{$absoluteUrl} = 1;

                my $response = $userAgent -> get($absoluteUrl);

                if (!$response -> is_success()) {
                    push @result, $absoluteUrl;
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Broken_Links
                \r=====================
                \r-h, --help       See this menu
                \r-t, --target     Define a web page to detect broken links\n\n";
        }

        return 0;
    }
}

1;
