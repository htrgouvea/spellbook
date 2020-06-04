package Modules::Recon::Host_Resolv;

use strict;
use warnings;
use Net::DNS;

sub new {
    my ($self, $hostname) = @_;

    if ($hostname) {
        my @result = ();

        my $resolver = Net::DNS::Resolver -> new();
        my $resolv = $resolver -> search($hostname);

        if ($resolv) {
            push @result, $hostname;
        }

        return @result;
    }
}

1;