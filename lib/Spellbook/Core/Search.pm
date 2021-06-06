package Spellbook::Core::Search {
    use strict;
    use warnings;

    sub new {
        my ($self, $modules, $search) = @_;

        foreach my $module (@{$modules -> {modules}}) {
            for (keys %{$module}) {
                my $value = $module -> {$_};
                
                if ($search =~ m/$value/g) {      
                    print "Module: ", ucfirst $module -> {category} . "::" . $module -> {module}, "\n";
                    print "Description: ", $module -> {description}, "\n";
                    print "=================================================", "\n\n";
                }
            }
        }

        return 1;
    }
}

1;