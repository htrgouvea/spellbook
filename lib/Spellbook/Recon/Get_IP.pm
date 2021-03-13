package Spellbook::Recon::Get_IP {
    use strict;
    use warnings;
    use Socket;

    sub new {
        my ($self, $hostname) = @_;
        my @results = ();

        if ($hostname) {
            my $ip = gethostbyname($hostname);

            if ($ip) {
                push @results, inet_ntoa($ip), "\n";
            }       
        }

        return @results;
    }
}

1;