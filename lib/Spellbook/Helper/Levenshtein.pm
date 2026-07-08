package Spellbook::Helper::Levenshtein {
    use strict;
    use warnings;
    use List::Util qw(min);

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $source, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            'source=s'   => \$source,
            't|target=s' => \$target
        );

        if (defined $source && defined $target) {
            my @source_chars = split //msx, $source;
            my @target_chars = split //msx, $target;
            my @distance;

            foreach my $i (0 .. @source_chars) {
                $distance[$i][0] = $i;
            }

            foreach my $j (0 .. @target_chars) {
                $distance[0][$j] = $j;
            }

            foreach my $i (1 .. @source_chars) {
                foreach my $j (1 .. @target_chars) {
                    my $cost = $source_chars[$i - 1] eq $target_chars[$j - 1] ? 0 : 1;

                    $distance[$i][$j] = min(
                        $distance[$i - 1][$j] + 1,
                        $distance[$i][$j - 1] + 1,
                        $distance[$i - 1][$j - 1] + $cost
                    );

                    if (
                        $i > 1
                        && $j > 1
                        && $source_chars[$i - 1] eq $target_chars[$j - 2]
                        && $source_chars[$i - 2] eq $target_chars[$j - 1]
                    ) {
                        $distance[$i][$j] = min($distance[$i][$j], $distance[$i - 2][$j - 2] + 1);
                    }
                }
            }

            return $distance[@source_chars][@target_chars];
        }

        if ($help) {
            return "\n"
                . "Helper::Levenshtein\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "    --source   First string to compare\n"
                . "-t, --target   Second string to compare\n\n";
        }

        return 0;
    }
}

1;
