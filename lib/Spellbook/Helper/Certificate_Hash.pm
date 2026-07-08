package Spellbook::Helper::Certificate_Hash {
    use strict;
    use warnings;
    use URI;
    use IO::Socket::SSL;
    use Readonly;

    our $VERSION = '0.0.2';

    Readonly my $DEFAULT_HTTPS_PORT => 443;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ /^https:\/\//msx) {
                $target = "https://$target";
            }

            my $uri = URI -> new($target);

            if ($uri -> scheme ne 'https' || !$uri -> host) {
                return 0;
            }

            my $host = $uri -> host;
            my $port = $uri -> port || $DEFAULT_HTTPS_PORT;

            my $client = IO::Socket::SSL -> new (
                PeerHost        => $host,
                PeerPort        => $port,
                SSL_hostname    => $host,
                SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE()
            );

            if (!$client) {
                return 0;
            }

            my $fingerprint = $client -> get_fingerprint('sha1');

            $client -> close();

            if (!$fingerprint) {
                return 0;
            }

            $fingerprint =~ s/^sha1[\$]//msx;

            push @result, $fingerprint;

            return @result;
        }

        if ($help) {
            return "\n"
                . "Helper::Certificate_Hash\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   HTTPS target (host, host:port, or URL) to fingerprint (SHA1)\n\n";
        }

        return 0;
    }
}

1;
