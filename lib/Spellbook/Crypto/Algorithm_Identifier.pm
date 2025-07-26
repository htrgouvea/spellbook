package Spellbook::Crypto::Algorithm_Identifier {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $data);

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            'h|help'   => \$help,
            'd|data=s' => \$data
        );

        if ($data) {
            $data =~ s/^\s+|\s+$//gx;

            my $uuid_chunk1 = qr/^[a-fA-F0-9]{8}/x;
            my $uuid_chunk2 = qr/-[a-fA-F0-9]{4}/x;
            my $uuid_chunk3 = qr/-[a-fA-F0-9]{4}/x;
            my $uuid_chunk4 = qr/-[a-fA-F0-9]{4}/x;
            my $uuid_chunk5 = qr/-[a-fA-F0-9]{12}$/x;

            my %patterns = (
                'Base64'    => qr/^[A-Za-z0-9+\/]+={0,2}$/x,
                'MD5'       => qr/^[a-fA-F0-9]{32}$/x,
                'SHA-1'     => qr/^[a-fA-F0-9]{40}$/x,
                'SHA-256'   => qr/^[a-fA-F0-9]{64}$/x,
                'UUID'      => qr/$uuid_chunk1$uuid_chunk2$uuid_chunk3$uuid_chunk4$uuid_chunk5/x,
                'Bcrypt'    => qr/^\$2[aby]\$\d{2}\$[A-Za-z0-9\.\/]{53}$/x,
            );

            foreach my $type (keys %patterns) {
                if ($data =~ $patterns{$type}) {
                    if ($type eq 'Base64') {
                        if (length($data) % 4 != 0 || $data !~ /[+\/=]/x) {
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
            return
                "\rHelper::Algorithm_Identifier" .
                "\r=====================" .
                "\r\t-h, --help     See this menu" .
                "\r\t-d, --data     Define the payload data to be identified\n\n";
        }

        return 0;
    }   
}

1;