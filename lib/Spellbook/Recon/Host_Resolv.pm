package Spellbook::Recon::Host_Resolv {
    use strict;
    use warnings;
    use Net::DNS;

    sub new {
        my ($self, $hostname) = @_;
        my @result = ();

        if ($hostname) {
            my $resolver = Net::DNS::Resolver -> new();
            my $search  = $resolver -> search($hostname);

            if ($search) {
                push @result, $hostname, "\n";
            } 
        }
        
        return @result;
    }
}

1;