package Spellbook::Core::Resources {
    use strict;
    use warnings;
    use Mojo::File;
    use Mojo::JSON qw(decode_json);

    our $VERSION = '0.0.3';

    my $CORE         = Mojo::File -> new(__FILE__) -> to_abs -> dirname;
    my $LIBRARY      = $CORE -> dirname -> dirname;
    my $DISTRIBUTION = $LIBRARY -> dirname;

    my $CACHE;

    sub _registry {
        if ($ENV{SPELLBOOK_MODULES}) {
            return Mojo::File -> new($ENV{SPELLBOOK_MODULES});
        }

        my $working = Mojo::File -> new('.config', 'modules.json');

        if (-r $working) {
            return $working;
        }

        return $DISTRIBUTION -> child('.config', 'modules.json');
    }

    sub new {
        if ($CACHE) {
            return $CACHE;
        }

        my $modules = decode_json(_registry() -> slurp());

        $CACHE = $modules;

        return $modules;
    }
}

1;
