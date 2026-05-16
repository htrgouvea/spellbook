package Spellbook::Core::Module {
    use strict;
    use warnings;
    use Spellbook::Core::Resources;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $module, @parameters) = @_;

        my $resources = Spellbook::Core::Resources -> new();

        foreach my $package (@{$resources -> {modules}}) {
            my $category = ucfirst $package -> {category};
            my $name = $category . q{::} . $package -> {module};

            if ($name eq $module) {
                require q{Spellbook/} . $category . q{/} . $package -> {module} . q{.pm};

                my @run = "Spellbook::$name" -> new(@parameters);
                my @results;

                foreach my $result (@run) {
                    if (defined($result) && $result ne '0') {
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
