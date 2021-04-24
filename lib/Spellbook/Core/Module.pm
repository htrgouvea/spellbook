package Spellbook::Core::Module {
    use strict;
    use warnings;

    sub new {
        my ($self, $modules, $module, $target, $parameter) = @_;

        foreach my $package (@{$modules -> {"modules"}}) {
            # i need refact everything's here ;)
            my $category = ucfirst $package -> {category};
            my $name =  $category . "::" . $package -> {module};

            if ($name eq $module) {  
                require "Spellbook/" . $category . "/" . $package -> {module} . ".pm";
                my @run = "Spellbook::$name" -> new($target, $parameter);
                
                foreach my $result (@run) {
                    print $result;
                }
            }
        }

        return 1;
    }
}

1;