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
            my $handle = Mojo::File -> new($file) -> openr();

            while (defined(my $line = $handle -> getline())) {
                chomp $line;

                if ($entrypoint) {
                    my $return = Spellbook::Core::Module -> new($entrypoint, ['--target' => $line]);

                    if ($return) {
                        push @result, $line;
                    }
                }

                if (!$entrypoint) {
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
