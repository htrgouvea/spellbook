package Spellbook::Recon::Dorking {
    use strict;
    use warnings;
    use WWW::Mechanize;
    use Mojo::Util qw(url_escape);
    use Readonly;

    Readonly my $DEFAULT_PAGE => 10;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $dork, @result);

        my $page = $DEFAULT_PAGE;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'   => \$help,
            'd|dork=s' => \$dork,
            'p|page=i' => \$page
        );
        
        if ($dork) {
            $dork = url_escape($dork);

            my %seen  = ();
            my $mech = WWW::Mechanize -> new();

            $mech -> ssl_opts (verify_hostname => 0);

            for (0 .. $page) {
                my $url = "https://wwww.bing.com/search?q=${dork}&first=${page}0";

                $mech -> get($url);

                my @links = $mech -> links();

                foreach my $link (@links) {
                    $url = $link -> url();

                    next if $seen{$url}++;

                    if ($url =~ m/^https?/xsm && $url !~ m/bing|live|microsoft|msn/xsm) {
                        push @result, $url;
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Dorking
                \r=====================
                \r-h, --help     See this menu
                \r-d, --dork     Set a dork to search
                \r-p, --page     Set the number of pages to search (default: " . $DEFAULT_PAGE . ")\n\n";
        }

        return 0;
    }
}

1;