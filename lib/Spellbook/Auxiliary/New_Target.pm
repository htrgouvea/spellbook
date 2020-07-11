package Spellbook::Auxiliary::New_Target;

use strict;
use warnings;

sub new {
    my ($self, $target) = @_;

    if ($target) {
        my @folders = ("recon", "notes", "files", "exploits", "proofs");
        my @recon = ("amass",  "notes", "emails", "shodan", "zoomeye", "nmap",  "headers");
        
        my @result = (); 

        foreach my $folder(@folders) {
            system("mkdir -p $target/$folder");

            if ($folder eq "recon") {
                foreach my $recon (@recon) {
                    system("mkdir $target/$folder/$recon");
                }
            }

            push @result, "created $target/$folder\n";
        }

        return @result;
    }
}

1;