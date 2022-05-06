package Spellbook::Helper::New_Target {
    use strict;
    use warnings;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=i" => \$target,
        );

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

            return @result;
        }

        if ($help) {
            return "
                \rHelper::New_Target
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Create a new target folder structure\n\n";
        }

        return 0;
    }
}

1;