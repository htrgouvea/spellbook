package Spellbook::Core::Search {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $INDEX_NOT_FOUND => -1;

    sub new {
        my ($self, $search, @results) = @_;

        my $resources = Spellbook::Core::Resources -> new();

        foreach my $module (@{$resources -> {modules}}) {
            for (keys %{$module}) {
                my $value = lc $module -> {$_};

                if (index($value, lc $search) != $INDEX_NOT_FOUND) {
                    print "\nModule: ", ucfirst $module -> {category} . '::' . $module -> {module}, "\n";
                    print 'Description: ', $module -> {description}, "\n";
                    print '=================================================', "\n";
                }
            }
        }

        return @results;
    }
}

1;
