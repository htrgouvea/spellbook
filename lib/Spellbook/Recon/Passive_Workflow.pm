package Spellbook::Recon::Passive_Workflow {
    use strict;
    use warnings;
    use Spellbook::Recon::Host_Resolv;
    use Spellbook::Recon::Get_IP;
    use Spellbook::Recon::Shodan_Enum;

    sub new {
        my ($self, $hostname) = @_;
        my @results = ();

        if ($hostname) {
            my $resolv = Spellbook::Recon::Host_Resolv -> new($hostname);

            if ($resolv) {
                my @ip = Spellbook::Recon::Get_IP -> new($hostname);
                if ($ip[0]) {
                    my @shodan = Spellbook::Recon::Shodan_Enum -> new($ip[0]);
                    push @results, @shodan;
                }
            }
        }

        return @results;
    }
}

1;