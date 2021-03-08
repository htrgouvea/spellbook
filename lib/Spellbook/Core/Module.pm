package Spellbook::Core::Module {
    use strict;
    use warnings;

    sub new {
        my ($self, $modules, $module, $target, $parameter) = @_;

        foreach my $package (@{$modules -> {"modules"}}) {
            if ($package -> {module} eq $module) {                    
                require "Spellbook/" . $package -> {location};

                my @run = "Spellbook::$module" -> new($target, $parameter);
                
                foreach my $result (@run) {
                    print $result;
                }
            }
        }

        return 1;
    }
}

1;