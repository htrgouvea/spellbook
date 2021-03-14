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
            # $ua -> ssl_opts(verify_hostname => 0);

            try {
                my $request = $ua -> head("http://$hostname");
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