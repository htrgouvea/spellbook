package Spellbook::Helper::Read_File {
    use strict;
    use warnings;
    use Spellbook::Core::Module;

    sub new {
        my ($self, $filename, $parameter) = @_;
        
        my @results = ();

        if ($filename) {
            my $resources = Spellbook::Core::Resources -> new();
            
            open (my $file, "<", $filename);

            while (<$file>) {
                chomp ($_);

                if ($parameter) {
                    my $return = Spellbook::Core::Module -> new ($resources, $parameter, $_);
                }

                else {
                    push @results, $_, "\n";
                }
            }

            close ($file);
        }

        return @results;
    }
}

1;