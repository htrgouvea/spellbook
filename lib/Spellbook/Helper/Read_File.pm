package Spellbook::Helper::Read_File {
    use strict;
    use warnings;
    use Spellbook::Core::Module;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file, $entrypoint, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "f|file=s" => \$file,
            "e|entrypoint=s" => \$entrypoint
        );

        if ($file) {
            open (my $filename, "<", $file);

            while (<$filename>) {
                chomp ($_);

                if ($entrypoint) {
                    my $resources = Spellbook::Core::Resources -> new();
                    my $return = Spellbook::Core::Module -> new ($resources, $entrypoint, ["--target" => $_]);
                }

                else {
                    push @result, $_,;
                }
            }

            close ($filename);

            return @result;
        }

        if ($help) {
            return "
                \rHelper::Read_File
                \r=====================
                \r-h, --help        See this menu
                \r-f, --file        Define a file to read
                \r-e, --entrypoint  Set a other module to send the output\n\n";
        }
        
        return 0;
    }
}

1;