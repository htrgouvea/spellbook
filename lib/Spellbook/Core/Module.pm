package Spellbook::Core::Module {
    use strict;
    use warnings;

    sub new {
        my ($self, $modules, $module, $target) = @_;

        foreach my $package (@{$modules -> {"modules"}}) {
            if ($package -> {module} eq $module) {
                    
                my $location = $package -> {location};
                    
                require "Spellbook/" . $location;
                    
                my @run = "Spellbook::$module" -> new($target);
                    
                foreach my $result (@run) {
                    print $result;
                }
            }
        }

        return 1;
    }
}

1;


            
