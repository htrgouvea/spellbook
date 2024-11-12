package Spellbook::Core::Module {
    use strict;
    use warnings;
    use Spellbook::Core::Resources;
    use Carp qw(croak);

    sub new {
        my ($self, $module, @parameters) = @_;

        my $resources = Spellbook::Core::Resources->new();

        foreach my $package (@{$resources->{modules}}) {
            my $category = ucfirst $package->{category};
            my $name = $category . "::" . $package->{module};

            if ($name eq $module) {
                my $module_path = "Spellbook::" . $category . "::" . $package->{module};

                my $success = eval {
                    require Module::Load;
                    Module::Load::load($module_path);
                    1;
                };

                if (!$success || $@) {
                    croak "Failed to load module $module_path: $@";
                }

                my @run = $module_path->new(@parameters);
                my @results;

                foreach my $result (@run) {
                    if (defined($result) && $result ne "0") {
                        push @results, $result;
                    }
                }

                return @results;
            }
        }

        return "\n[!] Module not found.\n\n";
    }
}

1;