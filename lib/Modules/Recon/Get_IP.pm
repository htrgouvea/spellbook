package Modules::Recon::Get_IP;

use strict;
use warnings;
use Socket;

sub new {
    my ($self, $hostname) = @_;

    if ($hostname) {
        my @result = ();

        my $ip = gethostbyname($hostname);
        my $toString = inet_ntoa($ip);
        
        push @result, $toString;

        return @result;
    }
}

1;