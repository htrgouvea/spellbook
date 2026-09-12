package Spellbook::Core::Credentials {
    use strict;
    use warnings;
    use Mojo::File;
    use Mojo::JSON qw(decode_json encode_json);
    use Getopt::Long;

    our $VERSION = '0.0.2';

    my $CACHE;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $platform, $value);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'       => \$help,
            'p|platform=s' => \$platform,
            'v|value=s'    => \$value,
        );

        if ($platform) {
            my $credentials = Mojo::File -> new('.config/credentials.json');

            # Read and parse the credentials file once, then reuse the decoded
            # structure. Under the threaded Orchestrator this module is called
            # once per target, so re-slurping an invariant file each time was
            # pure overhead (same class as the Core::Resources fix).
            if (!$CACHE) {
                $CACHE = decode_json($credentials -> slurp());
            }

            if ($value) {
                $CACHE -> {$platform} = $value;
                $credentials -> spurt(encode_json($CACHE));
            }

            return $CACHE -> {$platform};
        }

        if ($help) {
            return "\n"
                . "Core::Credentials\n"
                . "==============\n"
                . "-h, --help       See this menu\n"
                . "-p, --platform   Read some credentials filtering by platform\n"
                . "-v, --value      Define a value of a platform\n\n";
        }

        return 0;
    }
}

1;