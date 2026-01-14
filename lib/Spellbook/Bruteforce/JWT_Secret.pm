package Spellbook::Bruteforce::JWT_Secret {
    use strict;
    use warnings;
    use MIME::Base64;
    use Digest::SHA qw(hmac_sha256 hmac_sha384 hmac_sha512);
    use Mojo::JSON qw(decode_json);
    use Spellbook::Helper::Read_File;
    use Getopt::Long;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $token, $wordlist);

        my $encode_base64url = sub {
            my ($data) = @_;
            my $encoded = encode_base64($data, '');
            $encoded =~ tr/+\//-_/;
            $encoded =~ s/=+$//;
            return $encoded;
        };

        my $decode_base64url = sub {
            my ($data) = @_;
            my $normalized = $data;
            $normalized =~ tr/-_/+\//;
            my $padding_length = length($normalized) % 4;

            if ($padding_length) {
                my $padding_needed = 4 - $padding_length;
                $normalized = $normalized . ('=' x $padding_needed);
            }

            return decode_base64($normalized);
        };

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            'h|help'       => \$help,
            't|token=s'    => \$token,
            'w|wordlist=s' => \$wordlist
        );

        if ($token && $wordlist) {
            my @segments = split(/\./x, $token, -1);

            if (scalar(@segments) != 3) {
                return "\n[!] Invalid JWT format.\n";
            }

            my ($header_b64, $payload_b64, $signature_b64) = @segments;

            if (!$header_b64 || !$payload_b64 || !$signature_b64) {
                return "\n[!] Invalid JWT format.\n";
            }

            my $header_json = $decode_base64url -> ($header_b64);

            if (!$header_json) {
                return "\n[!] Unable to decode JWT header.\n";
            }

            my $header_data;
            my $decode_ok = eval {
                $header_data = decode_json($header_json);
                1;
            };

            if (!$decode_ok) {
                return "\n[!] Invalid JWT header JSON.\n";
            }

            my $algorithm = $header_data -> {alg};

            if (!$algorithm) {
                return "\n[!] JWT header does not define an algorithm.\n";
            }

            my %signers = (
                HS256 => sub { return hmac_sha256($_[0], $_[1]); },
                HS384 => sub { return hmac_sha384($_[0], $_[1]); },
                HS512 => sub { return hmac_sha512($_[0], $_[1]); }
            );

            my $signer = $signers{$algorithm};

            if (!$signer) {
                return "\n[!] Unsupported algorithm: $algorithm\n";
            }

            my @secrets = Spellbook::Helper::Read_File -> new(['--file' => $wordlist]);
            my $signing_input = "$header_b64.$payload_b64";

            foreach my $secret (@secrets) {
                chomp($secret);

                if ($secret eq '') {
                    next;
                }

                my $raw_signature = $signer -> ($signing_input, $secret);
                my $encoded_signature = $encode_base64url -> ($raw_signature);

                if ($encoded_signature eq $signature_b64) {
                    return "\n[+] Secret found: $secret\n";
                }
            }

            return "\n[!] Secret not found in wordlist.\n";
        }

        if ($help) {
            return
                "\rBruteforce::JWT_Secret\n"
              . "\r=======================\n"
              . "\r\t-h, --help      See this menu\n"
              . "\r\t-t, --token     JWT token to test\n"
              . "\r\t-w, --wordlist  Path to a secret wordlist\n\n";
        }

        return 0;
    }
}

1;
