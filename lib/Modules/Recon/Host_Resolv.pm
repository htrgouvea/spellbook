package Modules::Recon::Host_Resolv;

use strict;
use warnings;
use Net::DNS;

sub new {
    my ($self, $hostname) = @_;

    if ($hostname) {
        my @result = ();
        open (my $file, "<", $hostname);

        while (<$file>) {
            chomp($_);

            my $resolver = Net::DNS::Resolver -> new();
            my $resolv = $resolver -> search($_);

            if ($resolv) {
                push @result, $_, "\n";
            }
        }

        close ($file);
        return @result;
    }
}

1;