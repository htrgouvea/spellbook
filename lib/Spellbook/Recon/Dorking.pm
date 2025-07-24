package Spellbook::Recon::Dorking {
    use strict;
    use warnings;
    use WWW::Mechanize;
    use Mojo::Util qw(url_escape);

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $dork, @result);
        
        my $page = 10;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"   => \$help,
            "d|dork=s" => \$dork,
            "p|page=i" => \$page
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

                    if ($url =~ m/^https?/x && $url !~ m/bing|live|microsoft|msn/x) {
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
                \r-p, --page     Set the number of pages to search (default: 10)
                \r\n
                \r \n\n";
        }

        return 0;
    }
}

1;