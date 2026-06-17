package Spellbook::Core::UserAgent {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use LWP::ConnCache;

    our $VERSION = '0.0.2';

    our $shared_connection_cache = LWP::ConnCache -> new();

    sub new {
        my $user_agent = LWP::UserAgent -> new (
            timeout  => 5,
            ssl_opts => {
                verify_hostname => 0,
                SSL_verify_mode => 0
            },
            agent      => 'Spellbook / v0.3.8',
            conn_cache => $shared_connection_cache
        );

        $user_agent -> default_headers -> push_header('Cache-Control' => 'no-cache');

        return $user_agent;
    }
}

1;
