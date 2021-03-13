package Spellbook::Recon::Get_Headers {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use Try::Tiny;

    sub new {
        my ($self, $hostname) = @_;

        my @results = ();

        if ($hostname) {
            my $ua = LWP::UserAgent -> new();

            try {
                my $request = $ua -> head("https://$hostname");
                push @results, $request -> headers_as_string, "\n";
            }

            catch {
                #
            }
            
        }

        return @results;
    }
}

1;