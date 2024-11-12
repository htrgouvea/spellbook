package Spellbook::Helper::Read_File {
    use strict;
    use warnings;
    use Spellbook::Core::Module;
    use Carp qw(croak);

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $file, $entrypoint, @result);

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            "h|help"         => \$help,
            "f|file=s"       => \$file,
            "e|entrypoint=s" => \$entrypoint
        );

        if ($file) {
            local $/ = "\n";
            open my $fh, "<", $file or croak "Failed to open file: $!";
            my @lines = <$fh>;
            close $fh;

            for my $line (@lines) {
                chomp($line);

                if ($entrypoint) {
                    my $return = Spellbook::Core::Module->new($entrypoint, ["--target" => $line]);
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

        return <<"EOT";

Helper::Read_File
=====================
-h, --help        See this menu
-f, --file        Define a file to read
-e, --entrypoint  Set a other module to send the output

EOT
    }
}

1;