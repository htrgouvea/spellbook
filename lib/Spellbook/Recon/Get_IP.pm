package Spellbook::Recon::Get_IP;

use strict;
use warnings;
use Socket;

sub new {
    my ($self, $hostname) = @_;

    if ($hostname) {
        my @result = ();
        open (my $file, "<", $hostname);

        while (<$file>) {
            chomp ($_);
            my $ip = gethostbyname($_);
            my $toString = inet_ntoa($ip);
        
            push @result, $toString, "\n";
        }

        close ($file);
        return @result;
    }
}

1;