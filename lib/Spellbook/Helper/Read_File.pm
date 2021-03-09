package Spellbook::Helper::Read_File {
    use strict;
    use warnings;
    use Spellbook::Core::Module;

    sub new {
        my ($self, $filename, $parameter) = @_;
        
        if ($filename) {
            my $resources = Spellbook::Core::Resources -> new();
            
            open (my $file, "<", $filename);

            while (<$file>) {
                chomp ($_);

                if ($parameter) {
                    my $return = Spellbook::Core::Module -> new ($resources, $parameter, $_);
                }
            }

            close ($file);
        }
        

    }
}

1;