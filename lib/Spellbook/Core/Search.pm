package Spellbook::Core::Search {
    use strict;
    use warnings;

    sub new {
        my ($self, $search) = @_;

        my $resources = Spellbook::Core::Resources -> new();
        
        foreach my $module (@{$resources -> {modules}}) {
            for (keys %{$module}) {
                my $value = lc $module -> {$_};
                
                if ($search =~ m/$value/g) {
                    print "\nModule: ", ucfirst $module -> {category} . "::" . $module -> {module}, "\n";
                    print "Description: ", $module -> {description}, "\n";
                    print "=================================================", "\n";
                }
            }
        }
    }
}

1;