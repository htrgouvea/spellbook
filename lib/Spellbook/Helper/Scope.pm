package Spellbook::Helper::Scope {
    use strict;
    use warnings;
    use YAML::Tiny;
    use Readonly;
    use Spellbook::Core::Module;
    use Spellbook::Core::Orchestrator;

    our $VERSION = '0.0.2';

    Readonly my $DEFAULT_THREADS => 10;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $scope, $information, $entrypoint, $save, $keep, @results);

        my $threads = $DEFAULT_THREADS;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'          => \$help,
            'S|scope=s'       => \$scope,
            'i|information=s' => \$information,
            'e|entrypoint=s'  => \$entrypoint,
            't|threads=i'     => \$threads,
            'K|keep'          => \$keep,
            'save:s'          => \$save
        );

        if ($scope && $information) {
            my $yamlfile = YAML::Tiny -> read($scope);

            if ($entrypoint) {
                my @response = Spellbook::Core::Orchestrator -> new(
                    [
                        '--entrypoint'  => $entrypoint,
                        '--list'        => $yamlfile -> [0] -> {$information},
                        '--threads'     => $threads
                    ]
                );

                push @results, @response;
            }

            if (!$entrypoint) {
                foreach my $info (@{$yamlfile -> [0] -> {$information}}) {
                    push @results, $info;
                }
            }

            if ($save) {
                if ($keep && exists $yamlfile -> [0] -> {$save}) {
                    push @{$yamlfile -> [0] -> {$save}}, @results;
                }

                if (!$keep || !exists $yamlfile -> [0] -> {$save}) {
                    $yamlfile -> [0] -> {$save} = [@results];
                }

                $yamlfile -> write($scope);
            }

            return @results;
        }

         if ($help) {
            return "\n"
                . "Helper::Scope\n"
                . "=====================\n"
                . "-h, --help         See this menu\n"
                . "-S, --scope        Define a YML file as a scope\n"
                . "-i, --information  Set an information to extract from your scope\n"
                . "-e, --entrypoint   Send informations to another entrypoint module\n"
                . "-K, --keep         Keep the current values in the file and add news values\n"
                . "--save             Save the output on some attribute\n";
        }

        return 0;
    }
}

1;
