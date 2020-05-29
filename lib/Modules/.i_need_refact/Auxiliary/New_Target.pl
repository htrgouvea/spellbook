
#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;

sub main {
    my $target = $ARGV[0];

    if ($target) {
        my @folders = ("recon", "notes", "files", "exploits", "proofs");
        my @recon = ("amass",  "notes", "emails", "shodan", "zoomeye", "nmap",  "headers");

        foreach my $folder(@folders) {
            system("mkdir $target/$folder");

            if ($folder eq "recon") {
                foreach my $recon (@recon) {
                    system("mkdir $target/$folder/$recon");
                }
            }
        }
    }
}

main();
exit;