package Spellbook::Core::UserAgent {
    use strict;
    use warnings;
    use parent -norequire, 'LWP::UserAgent';
    use LWP::UserAgent;

    our $VERSION = '0.0.3';

    our $FALLBACK = 1;

    sub new {
        my ($class, @options) = @_;

        my $self = LWP::UserAgent -> new (
            timeout  => 5,
            ssl_opts => {
                verify_hostname => 0,
                SSL_verify_mode => 0
            },
            agent => 'Spellbook / v0.3.8',
            @options
        );

        $self -> default_headers -> push_header('Cache-Control' => 'no-cache');

        return bless $self, __PACKAGE__;
    }

    sub simple_request {
        my ($self, $request, @rest) = @_;

        my $response = $self -> SUPER::simple_request($request, @rest);

        if (!$FALLBACK) {
            return $response;
        }

        my $warning = $response -> header('Client-Warning') || q{};

        if ($warning ne 'Internal response') {
            return $response;
        }

        my $uri = $request -> uri();

        # A relative or non-network URI is parsed into a class that has no
        # host method at all, and LWP reports those through the same
        # Client-Warning header as a failed lookup.
        if (!$uri || !$uri -> can('host')) {
            return $response;
        }

        my $host = $uri -> host();

        if (!$host || ($host =~ /\A[\d.]+\z/msx) || ($host =~ /:/msx)) {
            return $response;
        }

        require Spellbook::Recon::DoH_Resolv;

        my $address;

        {
            local $FALLBACK = 0;  ## no critic (Variables::ProhibitLocalVars)
            ($address) = Spellbook::Recon::DoH_Resolv -> new(['--target' => $host]);
        }

        if (!$address) {
            return $response;
        }

        my $pinned = $request -> clone();
        my $target = $pinned -> uri -> clone();

        $target -> host($address);
        $pinned -> uri($target);
        $pinned -> header('Host' => $host);

        my $previous = $self -> ssl_opts('SSL_hostname');
        $self -> ssl_opts('SSL_hostname' => $host);

        my $retry = eval { $self -> SUPER::simple_request($pinned, @rest) };

        $self -> ssl_opts('SSL_hostname' => $previous);

        if (!$retry) {
            return $response;
        }

        # The response carries the pinned URI, so LWP would resolve a relative
        # Location against the address instead of the name. Put the original
        # request back on it before anything follows a redirect.
        $retry -> request($request);

        return $retry;
    }
}

1;
