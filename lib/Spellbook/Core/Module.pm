package Spellbook::Core::Module {
    use strict;
    use warnings;
    use Spellbook::Core::Resources;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $module, @parameters) = @_;

        my $resources = Spellbook::Core::Resources -> new();

        foreach my $package (@{$resources -> {modules}}) {
            my $category = ucfirst $package -> {category};
            my $name = $category . q{::} . $package -> {module};

            if ($name eq $module) {
                my $file = q{Spellbook/} . $category . q{/} . $package -> {module} . q{.pm};

                if (!eval { require $file; 1 }) {
                    my $error = $@;  ## no critic (Variables::ProhibitPunctuationVars)

                    if ($error =~ /\ACan't[ ]locate[ ]\Q$file\E/msx) {
                        return "\n[!] Module not found.\n\n";
                    }

                    return "\n[!] Unable to load $name: $error\n";
                }

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
