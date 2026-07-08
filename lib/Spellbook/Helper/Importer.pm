package Spellbook::Helper::Importer {
    use strict;
    use warnings;
    use Mojo::File;
    use YAML::Tiny;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $file, $information, $scope, $keep);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'          => \$help,
            'f|file=s'        => \$file,
            'i|information=s' => \$information,
            'S|scope=s'       => \$scope,
            'K|keep'          => \$keep
        );

        if ($file && $information && $scope) {
            my $handle   = Mojo::File -> new($file) -> open();
            my $yamlfile = YAML::Tiny -> read($scope);
            my @entries;

            while (defined(my $line = $handle -> getline())) {
                chomp $line;

                if ($line) {
                    push @entries, $line;
                }
            }

            if ($keep && exists $yamlfile -> [0] -> {$information}) {
                my %seen = map { $_ => 1 } @{$yamlfile -> [0] -> {$information}};
                push @{$yamlfile -> [0] -> {$information}}, grep { !$seen{$_}++ } @entries;
            }

            if (!$keep || !exists $yamlfile -> [0] -> {$information}) {
                $yamlfile -> [0] -> {$information} = \@entries;
            }

            $yamlfile -> write($scope);

            return @entries;
        }

        if ($help) {
            return "\n"
                . "Helper::Importer\n"
                . "=====================\n"
                . "Import values from a file into a key of a YAML file (e.g. a Helper::Scope file).\n\n"
                . "-h, --help         See this menu\n"
                . "-f, --file         File to import entries from\n"
                . "-i, --information  Key/tag in the YAML scope to write into\n"
                . "-S, --scope        YAML scope file to update\n"
                . "-K, --keep         Keep existing values and append (deduplicates)\n\n";
        }

        return 0;
    }
}

1;
