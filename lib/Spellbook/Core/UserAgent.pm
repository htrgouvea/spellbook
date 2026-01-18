package Spellbook::Core::UserAgent {
    use strict;
    use warnings;
    use LWP::UserAgent;

    our $VERSION = '0.0.2';

    our $sharedUserAgent;

    sub new {
        if (defined $sharedUserAgent) {
            return $sharedUserAgent;
        }

        my $userAgent = LWP::UserAgent -> new (
            timeout  => 5,
            ssl_opts => {
                verify_hostname => 0,
                SSL_verify_mode => 0
            },
            agent => 'Spellbook / v0.3.8'
        );

        $userAgent -> default_headers -> push_header("Cache-Control" => "no-cache");

        $sharedUserAgent = $userAgent;

        return $sharedUserAgent;
    }
}

1;
