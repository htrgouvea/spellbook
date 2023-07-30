package Spellbook::Core::UserAgent {
    use strict;
    use warnings;
    use LWP::UserAgent;

    sub new {
        my $userAgent = LWP::UserAgent -> new (
            timeout  => 5,
            ssl_opts => { 
                verify_hostname => 0,
                SSL_verify_mode => 0
            },
            agent => "Spellbook / v0.3.2"
        );

        return $userAgent;
    }
}

1;