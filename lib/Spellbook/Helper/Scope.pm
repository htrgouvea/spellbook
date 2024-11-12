package Spellbook::Helper::Scope {
    use strict;
    use warnings;
    use YAML::Tiny;
    use Spellbook::Core::Module;
    use Spellbook::Core::Orchestrator;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $scope, $information, $entrypoint, $save, $keep, @results);

        my $threads = 10;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"          => \$help,
            "S|scope=s"       => \$scope,
            "i|information=s" => \$information,
            "e|entrypoint=s"  => \$entrypoint,
            "t|threads=i"     => \$threads,
            "K|keep"          => \$keep,
            "save:s"          => \$save
        );

        if ($scope && $information) {
            my $yamlfile = YAML::Tiny -> read($scope);

            if ($entrypoint) {
                my @response = Spellbook::Core::Orchestrator -> new (
                    [
                        "--entrypoint" => $entrypoint,
                        "--list"        => $yamlfile -> [0] -> {$information},
                        "--threads"     => $threads
                    ]
                );

                push @results, @response;
            }

            else {
                foreach my $info (@{$yamlfile -> [0] -> {$information}}) {
                    push @results, $info;
                }
            }

            if ($save) {
                if ($keep && exists $yamlfile->[0]->{$save}) {
                    push @{$yamlfile->[0]->{$save}}, @results;
                }

                else {
                    $yamlfile->[0]->{$save} = [@results];
                }

                $yamlfile->write($scope);
            }

            return @results;
        }

         if ($help) {
            return<<"EOT";

Helper::Scope
=====================
-h, --help         See this menu
-S, --scope        Define a YML file as a scope
-i, --information  Set an information to extract from your scope
-e, --entrypoint   Send informations to another entrypoint module
-K, --keep         Keep the current values in the file and add news values
--save             Save the output on some attribute\n\n";

EOT
        }

        return 0;
    }
}

1;