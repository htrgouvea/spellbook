package Spellbook::Helper::New_Target {
    use strict;
    use warnings;

    sub new {
        my ($self, $target) = @_;
        my @result = (); 

        if ($target) {
            my @folders = ("recon", "notes", "files");
            my @files   = ("exploits", "proofs");

            foreach my $folder (@folders) {
                if ($folder eq "files") {
                    foreach my $file (@files) {
                        system("mkdir -p $target/$folder/$file");
                    }
                }

                else {
                    system("mkdir -p $target/$folder");
                }

                push @result, "created $target/$folder\n";
            }
        }

        return @result;
    }
}

1;