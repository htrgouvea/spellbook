package Spellbook::Core::Resources {
    use strict;
    use warnings;
    use Mojo::File;
    use Mojo::JSON qw(decode_json);
    use Data::Dumper;

    sub new {
        my ($self) = @_;
        my $resources = Mojo::File -> new(".config/modules.json");
        
        if ($resources) {
            my $list = $resources -> slurp();
            my $modules = decode_json($list);

            return $modules;
        }

        return 1;
    }
}

1;