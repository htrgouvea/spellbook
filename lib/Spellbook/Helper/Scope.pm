package Spellbook::Helper::Scope {
    use strict;
    use warnings;
    use YAML::Tiny;
    use Spellbook::Core::Module;
    use Spellbook::Core::Resources;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $scope, $information, $entrypoint, $save, @results);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"          => \$help,
            "S|scope=s"       => \$scope,
            "i|information=s" => \$information,
            "e|entrypoint=s"  => \$entrypoint,
            "save=s"          => \$save
        );

        if ($scope && $information) {
            my $yamlfile = YAML::Tiny -> read($scope);
        
            foreach my $info (@{$yamlfile -> [0] -> {$information}}) {
                if ($entrypoint) {
                    my $resources = Spellbook::Core::Resources -> new();

                    my @return = Spellbook::Core::Module -> new (
                        $resources, 
                        $entrypoint, 
                        ["--target" => $info]
                    );

                    push @results, @return;
                } 

                else {
                    push @results, $info;
                }
            }

            if ($save) {
                $yamlfile -> [0] -> {$save} = [@results];
                $yamlfile -> write ($scope);
            }
                        
            return @results;
        }

         if ($help) {
            return "
                \rHelper::Scope
                \r=====================
                \r-h, --help         See this menu
                \r-S, --scope        Define a YML file as a scope
                \r-i, --information  Set an information to extract from your scope
                \r-e, --entrypoint   Send informations to another entrypoint module
                \r--save             Save the output on some attribute\n\n";
        }
        
        return 0;
    }
}

1;