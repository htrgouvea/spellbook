package Spellbook::Helper::Entropy {
    use strict;
    use warnings;
    use Readonly;

    our $VERSION = '0.0.2';

    Readonly my $LOG_TWO => log 2;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $threshold, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'        => \$help,
            't|target=s'    => \$target,
            'e|threshold=f' => \$threshold
        );

        if (defined $target) {
            foreach my $word (split /\s+/xsm, $target) {
                my $length = length $word;

                if ($length == 0) {
                    next;
                }

                my %frequency;

                foreach my $char (split //sm, $word) {
                    $frequency{$char}++;
                }

                my $entropy = 0;

                foreach my $char (keys %frequency) {
                    my $probability = $frequency{$char} / $length;
                    $entropy -= $probability * (log $probability) / $LOG_TWO;
                }

                if (defined $threshold && $entropy <= $threshold) {
                    next;
                }

                push @result, sprintf '%.4f', $entropy;
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Helper::Entropy\n"
                . "=====================\n"
                . "-h, --help        See this menu\n"
                . "-t, --target      Text whose words will have their Shannon entropy measured\n"
                . "-e, --threshold   Only return words with entropy above this value in bits\n\n";
        }

        return 0;
    }
}

1;
