package Spellbook::Recon::Get_Headers {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use Try::Tiny;

    sub new {
        my ($self, $hostname, $parameter) = @_;
        my @results = ();

        if ($hostname) {
            my $ua = LWP::UserAgent -> new(
                ssl_opts => { verify_hostname => 0 }
            );

            try {
                my $request = $ua -> get("https://$hostname");
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