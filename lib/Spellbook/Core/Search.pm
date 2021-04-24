package Spellbook::Core::Search {
    use strict;
    use warnings;

    sub new {
        my ($self, $modules, $search) = @_;

        foreach my $module (@{$modules -> {"modules"}}) {
            # i need refact everything's here ;)
            if ($search eq $module -> {category}) {
                my $name =  ucfirst $module -> {category} . "::" . $module -> {module};
                                
                print "Module: ", $name, "\n";
                print "Description: ", $module -> {description}, "\n";
                print "=================================================", "\n\n";
            }
        }

        return 1;
    }
}

1;