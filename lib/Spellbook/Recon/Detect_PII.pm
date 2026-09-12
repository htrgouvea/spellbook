package Spellbook::Recon::Detect_PII {
    use strict;
    use warnings;
    use Getopt::Long;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    ## no critic (ValuesAndExpressions::ProhibitMagicNumbers)

    sub new {  ## no critic (Subroutines::ProhibitExcessComplexity)
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            my $text = $target;

            if ($target =~ m{\Ahttps?://}ixsm) {
                $text = Spellbook::Core::UserAgent -> new() -> get($target) -> decoded_content() // q{};
            }

            my ($digits, $cpf, $cnpj, $luhn);

            $digits = sub {
                my ($value) = @_;
                $value =~ s/\D//gxsm;
                return $value;
            };

            $cpf = sub {
                my ($value) = $digits -> ($_[0]);

                if (length $value != 11 || $value =~ /\A(\d)\1{10}\z/xsm) {
                    return 0;
                }

                foreach my $size (9, 10) {
                    my $sum = 0;

                    foreach my $i (0 .. $size - 1) {
                        my $digit = substr $value, $i, 1;
                        $sum += $digit * ($size + 1 - $i);
                    }

                    my $expected = $sum * 10 % 11 % 10;

                    if ($expected != substr $value, $size, 1) {
                        return 0;
                    }
                }

                return 1;
            };

            $cnpj = sub {
                my $value = $digits -> ($_[0]);

                if (length $value != 14 || $value =~ /\A(\d)\1{13}\z/xsm) {
                    return 0;
                }

                my @weights = (6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);

                foreach my $size (12, 13) {
                    my @slice = @weights[($#weights - $size + 1) .. $#weights];
                    my $sum = 0;

                    foreach my $i (0 .. $size - 1) {
                        my $digit = substr $value, $i, 1;
                        $sum += $digit * $slice[$i];
                    }

                    my $remainder = $sum % 11;
                    my $expected = 0;

                    if ($remainder >= 2) {
                        $expected = 11 - $remainder;
                    }

                    if ($expected != substr $value, $size, 1) {
                        return 0;
                    }
                }

                return 1;
            };

            $luhn = sub {
                my $value = $digits -> ($_[0]);

                if (length $value < 13) {
                    return 0;
                }

                my $sum = 0;
                my $double = 0;

                foreach my $i (reverse 0 .. length($value) - 1) {
                    my $digit = substr $value, $i, 1;

                    if ($double) {
                        $digit *= 2;

                        if ($digit > 9) {
                            $digit -= 9;
                        }
                    }

                    $sum += $digit;
                    $double = !$double;
                }

                return $sum % 10 == 0;
            };

            my %validator = (
                CPF         => $cpf,
                CNPJ        => $cnpj,
                CREDIT_CARD => $luhn,
            );

            my @rules = (
                ['CPF',         qr/\b\d{3}[.]?\d{3}[.]?\d{3}-?\d{2}\b/xsm],
                ['CNPJ',        qr/\b\d{2}[.]?\d{3}[.]?\d{3}\/?\d{4}-?\d{2}\b/xsm],
                ['CREDIT_CARD', qr/\b(?:\d[ -]?){13,19}\b/xsm],
                ['EMAIL',       qr/\b[[:alnum:]._%+-]+@[[:alnum:].-]+[.][[:alpha:]]{2,}\b/xsm],
                ['UUID',        qr/\b[[:xdigit:]]{8}(?:-[[:xdigit:]]{4}){3}-[[:xdigit:]]{12}\b/xsm],
            );

            foreach my $rule (@rules) {
                my ($entity, $regex) = @{$rule};

                while ($text =~ /($regex)/gxsm) {
                    my $match = $1;
                    my $check = $validator{$entity};

                    if ($check && !$check -> ($match)) {
                        next;
                    }

                    push @result, "$entity: $match";
                }
            }

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Detect_PII\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Text to scan, or a URL to fetch and scan, for PII\n\n";
        }

        return 0;
    }
}

1;
