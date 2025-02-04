package Spellbook::Crypto::JWT_Content {
    use strict;
    use warnings;
    use MIME::Base64;
    use Getopt::Long;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $data);

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            "h|help"   => \$help,
            "d|data=s" => \$data
        );

        if ($data) {
            my ($header_b64, $payload_b64, $signature_b64) = split(/\./x, $data);

            if ($header_b64 && $payload_b64 && $signature_b64) {
                my $header  = decode_base64($header_b64);
                my $payload = decode_base64($payload_b64);

                return "$header$payload";
            }

            return 0;
        }

        if ($help) {
            return "
                \rHelper::JWT_Content
                \r=====================
                \r\t-h, --help     See this menu
                \r\t-d, --data     Define the payload data to visualize the content\n\n";
        }

        return 0;
    }
}

1;