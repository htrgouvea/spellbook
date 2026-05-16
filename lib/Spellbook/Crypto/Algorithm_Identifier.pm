package Spellbook::Crypto::Algorithm_Identifier {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $BASE64_MODULO => 4;
    Readonly my $MD5_LENGTH    => 32;
    Readonly my $SHA1_LENGTH   => 40;
    Readonly my $SHA256_LENGTH => 64;
    Readonly my $BCRYPT_LENGTH => 60;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $data);

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            'h|help'   => \$help,
            'd|data=s' => \$data
        );

        if ($data) {
            $data =~ s/^\s+|\s+$//gmsx;

            my $uuid_chunk1 = qr/^[[:xdigit:]]{8}/msx;
            my $uuid_chunk2 = qr/-[[:xdigit:]]{4}/msx;
            my $uuid_chunk3 = qr/-[[:xdigit:]]{4}/msx;
            my $uuid_chunk4 = qr/-[[:xdigit:]]{4}/msx;
            my $uuid_chunk5 = qr/-[[:xdigit:]]{12}$/msx;

            my %patterns = (
                'Base64'    => qr/^[[:alnum:]+\/]+={0,2}$/msx,
                'MD5'       => qr/^[[:xdigit:]]{32}$/msx,
                'SHA-1'     => qr/^[[:xdigit:]]{40}$/msx,
                'SHA-256'   => qr/^[[:xdigit:]]{64}$/msx,
                'UUID'      => qr/$uuid_chunk1$uuid_chunk2$uuid_chunk3$uuid_chunk4$uuid_chunk5/msx,
                'Bcrypt'    => qr/^\$2[aby]\$[[:digit:]]{2}\$[[:alnum:].\/]{53}$/msx,
            );

            foreach my $type (keys %patterns) {
                if ($data =~ $patterns{$type}) {
                    if ($type eq 'Base64') {
                        if (length($data) % $BASE64_MODULO != 0 || $data !~ /[+\/=]/msx) {
                            next;
                        }
                    }

                    if ($type eq 'MD5') {
                        if (length($data) != $MD5_LENGTH) {
                            next;
                        }
                    }

                    if ($type eq 'SHA-1') {
                        if (length($data) != $SHA1_LENGTH) {
                            next;
                        }
                    }

                    if ($type eq 'SHA-256') {
                        if (length($data) != $SHA256_LENGTH) {
                            next;
                        }
                    }

                    if ($type eq 'Bcrypt') {
                        if (length($data) != $BCRYPT_LENGTH) {
                            next;
                        }
                    }

                    return $type;
                }
            }

            return 'Desconhecido';
        }

        if ($help) {
            return "\n"
                . 'Helper::Algorithm_Identifier' . "\n"
                . '=====================' . "\n"
                . "\t-h, --help     See this menu\n"
                . "\t-d, --data     Define the payload data to be identified\n\n";
        }

        return 0;
    }
}

1;
