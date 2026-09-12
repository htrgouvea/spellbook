package Spellbook::Helper::Read_File {
    use strict;
    use warnings;
    use Getopt::Long;
    use Mojo::File;
    use Spellbook::Core::Module;

    our $VERSION = '0.0.3';

    my %CACHE;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file, $entrypoint, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'         => \$help,
            'f|file=s'       => \$file,
            'e|entrypoint=s' => \$entrypoint
        );

        if ($file) {
            # Pure file reads (no entrypoint) are invariant, so cache the lines
            # by filename. Callers that load a wordlist inside their per-target
            # new() (e.g. Bruteforce::*, Recon::DNS_Bruteforce) then re-read the
            # file only once instead of once per target. The entrypoint path is
            # never cached: it runs live per-line side effects.
            if (!$entrypoint && exists $CACHE{$file}) {
                return @{$CACHE{$file}};
            }

            my $handle = Mojo::File -> new($file) -> open();

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

            $handle -> close();

            if (!$entrypoint) {
                $CACHE{$file} = [@result];
            }

            return @result;
        }


        return "\n"
            . "Helper::Read_File\n"
            . "=====================\n"
            . "-h, --help        See this menu\n"
            . "-f, --file        Define a file to read\n"
            . "-e, --entrypoint  Set a other module to send the output as a target\n\n";
    }
}

1;
