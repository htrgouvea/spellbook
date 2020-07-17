package Spellbook::Auxiliary::New_Target;

use strict;
use warnings;

sub new {
    my ($self, $target) = @_;

    print $target;

    if ($target) {
        my @folders = ("recon", "notes", "files");
        my @recon   = ("amass", "emails", "shodan", "zoomeye", "nmap",  "headers");
        my @files   = ("exploits", "proofs");
        
        print "here";

        my @result = (); 

        foreach my $folder(@folders) {
            if ($folder eq "recon") {
                foreach my $recon (@recon) {
                    system("mkdir -p $target/$folder/$recon");
                }
            }

            elsif ($folder eq "files") {
                foreach my $file (@files) {
                    system("mkdir -p $target/$folder/$file");
                }
            }

            else {
                system("mkdir -p $target/$folder");
            }

            push @result, "created $target/$folder\n";
        }

        return @result;
    }
}

1;