package Spellbook::Core::Search {
    use strict;
    use warnings;

    sub new {
        my ($self, $modules, $search) = @_;

        foreach my $module (@{$modules -> {"modules"}}) {
            if ($search eq $module -> {category}) {
                print "Module: ", $module -> {module}, "\n";
                print "Category: ", $module -> {category}, "\n";
                print "Description: ", $module -> {description}, "\n";
                print "=================================================", "\n\n";
            }
        }

        return 1;
    }
}

1;