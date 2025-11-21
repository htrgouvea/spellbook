package Spellbook::Helper::Read_File {
    use strict;
    use warnings;
    use Mojo::File;
    use Spellbook::Core::Module;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file, $entrypoint, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'         => \$help,
            'f|file=s'       => \$file,
            'e|entrypoint=s' => \$entrypoint
        );

        if ($file) {
            my $content = Mojo::File -> new($file) -> slurp();
            my @content = split(/\n/, $content);

            foreach my $line (@content) {
                if ($entrypoint) {
                    my $return = Spellbook::Core::Module -> new($entrypoint, ['--target' => $line]);

                    if ($return) {
                        push @result, $line;
                    }
                }
                
                else {
                    push @result, $line;
                }
            }
            
            return @result;
        }


        return "
            \rHelper::Read_File
            \r=====================
            \r-h, --help        See this menu
            \r-f, --file        Define a file to read
            \r-e, --entrypoint  Set a other module to send the output as a target\n\n";
    }
}

1;