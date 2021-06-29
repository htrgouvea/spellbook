package Spellbook::Helper::Read_File {
    use strict;
    use warnings;
    use Spellbook::Core::Module;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file, $module, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "f|file=s" => \$file,
            # "m|module=s" => \$module
        );

        if ($file) {
            my $resources = Spellbook::Core::Resources -> new();

            open (my $filename, "<", $file);

            while (<$filename>) {
                chomp ($_);

                # if ($module) {
                #     my $return = Spellbook::Core::Module -> new ($resources, $module, $_);
                # }

                else {
                    push @result, $_, "\n";
                }
            }

            close ($filename);

            return @result;
        }

         if ($help) {
            return "
                \rHelper::Read_File
                \r=====================
                \r-h, --help     See this menu
                \r-f, --file     Define a file to read\n\n";
        }
        
        return 0;
    }
}

1;