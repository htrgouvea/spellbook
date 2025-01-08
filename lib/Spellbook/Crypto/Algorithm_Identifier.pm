package Spellbook::Crypto::Algorithm_Identifier {
    use strict;
    use warnings;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $data);

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            "h|help"   => \$help,
            "d|data=s" => \$data
        );

        if ($data) {
            $data =~ s/^\s+|\s+$//g;

            my %patterns = (
                'Base64'    => qr/^[A-Za-z0-9+\/]+={0,2}$/,
                'MD5'       => qr/^[a-fA-F0-9]{32}$/,
                'SHA-1'     => qr/^[a-fA-F0-9]{40}$/,
                'SHA-256'   => qr/^[a-fA-F0-9]{64}$/,
                'UUID'      => qr/^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$/,
                'Bcrypt'    => qr/^\$2[aby]\$\d{2}\$[A-Za-z0-9\.\/]{53}$/,
            );

            foreach my $type (keys %patterns) {
                if ($data =~ $patterns{$type}) {
                    if ($type eq 'Base64') {
                        if (length($data) % 4 != 0 || $data !~ /[+\/=]/) {
                            next;
                        }
                    }

                    if ($type eq 'MD5') {
                        if (length($data) != 32) {
                            next;
                        }
                    }

                    if ($type eq 'SHA-1') {
                        if (length($data) != 40) {
                            next;
                        }
                    }

                    if ($type eq 'SHA-256') {
                        if (length($data) != 64) {
                            next;
                        }
                    }

                    if ($type eq 'Bcrypt') {
                        if (length($data) != 60) {
                            next;
                        }
                    }

                    return $type;
                }
            }

            return "Desconhecido";
        }

        if ($help) {
            return "
                \rHelper::Algorithm_Identifier
                \r=====================
                \r\t-h, --help     See this menu
                \r\t-d, --data     Define the payload data to be identified\n\n";
        }

        return 0;
    }   
}

1;