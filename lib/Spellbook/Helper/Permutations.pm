package Spellbook::Helper::Permutations {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $value, @result);
        my $repeat = 1;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            'v|value=s'  => \$value,
            'r|repeat=i' => \$repeat
        );

        if ($value) {
            foreach (1 .. $repeat) {
                my @chars = split //msx, $value;

                foreach my $char_index (0 .. $#chars) {
                    my $random = int rand @chars;
                    my $temp   = $chars[$char_index];

                    $chars[$char_index] = $chars[$random];
                    $chars[$random] = $temp;
                }

                push @result, join '', @chars;
            }

            return @result;
        }

        if ($help) {
            return "
                \rHelper::Permutations
                \r=====================
                \r-h, --help     See this menu
                \r-v, --value    Provide a seed
                \r-r, --repeat   Quantities of repetitions\n\n";
        }

        return 0;
    }
}

1;
