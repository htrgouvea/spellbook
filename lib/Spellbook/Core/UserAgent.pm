package Spellbook::Core::UserAgent {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use LWP::ConnCache;

    our $VERSION = '0.0.2';

    our $sharedConnectionCache = LWP::ConnCache -> new();

    sub new {
        my $userAgent = LWP::UserAgent -> new (
            timeout  => 5,
            ssl_opts => {
                verify_hostname => 0,
                SSL_verify_mode => 0
            },
            agent => 'Spellbook / v0.3.8',
            conn_cache => $sharedConnectionCache
        );

        $userAgent -> default_headers -> push_header("Cache-Control" => "no-cache");

        return $userAgent;
    }
}

1;
