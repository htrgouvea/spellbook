package Spellbook::Core::Request {
    use strict;
    use warnings;
    use LWP::UserAgent;

    sub new {
        my $userAgent = LWP::UserAgent -> new (
             ssl_opts => { 
                verify_hostname => 0,
                SSL_verify_mode => 0
            },
            timeout => 10,
            agent => 'Spellbook / 0.3.2',
        );

        return $userAgent;
    }

    
}

1;