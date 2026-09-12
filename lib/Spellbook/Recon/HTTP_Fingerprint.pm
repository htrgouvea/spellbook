package Spellbook::Recon::HTTP_Fingerprint {
    use strict;
    use warnings;
    use Getopt::Long;
    use URI;
    use LWP::UserAgent;
    use Spellbook::Recon::DoH_Resolv;

    our $VERSION = '0.0.2';

    use Readonly;
    Readonly my $TIMEOUT     => 15;
    Readonly my $TITLE_LIMIT => 72;

    sub _agent {
        my ($host, $follow) = @_;

        my $user_agent = LWP::UserAgent -> new (
            timeout  => $TIMEOUT,
            agent    => 'Spellbook / v0.3.8',
            ssl_opts => {
                verify_hostname => 0,
                SSL_verify_mode => 0,
                SSL_hostname    => $host
            }
        );

        $user_agent -> default_headers -> push_header('Cache-Control' => 'no-cache');

        if (!$follow) {
            $user_agent -> max_redirect(0);
        }

        return $user_agent;
    }

    sub _fetch {
        my ($uri, $host, $ip, $follow) = @_;

        my $user_agent = _agent($host, $follow);

        if (!$ip) {
            return $user_agent -> get($uri -> as_string);
        }

        my $pinned = $uri -> clone();
        $pinned -> host($ip);

        return $user_agent -> get($pinned -> as_string, Host => $host);
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $follow, $ip, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'i|ip=s'     => \$ip,
            'f|follow'   => \$follow
        );

        if ($target) {
            if ($target !~ m{^https?://}ixsm) {
                $target = "https://$target";
            }

            my $uri  = URI -> new($target);
            my $host = $uri -> host();

            if (!$host) {
                return @result;
            }

            my $response = _fetch($uri, $host, $ip, $follow);
            my $warning  = $response -> header('Client-Warning') || q{};

            if (($warning eq 'Internal response') && !$ip) {
                my ($resolved) = Spellbook::Recon::DoH_Resolv -> new(['--target' => $host]);

                if ($resolved) {
                    $response = _fetch($uri, $host, $resolved, $follow);
                    $warning  = $response -> header('Client-Warning') || q{};
                }
            }

            if ($warning eq 'Internal response') {
                return @result;
            }

            my $status = $response -> code();
            my $server = $response -> header('Server') || q{-};
            my $length = $response -> header('Content-Length');

            if (!defined $length) {
                $length = length($response -> content // q{});
            }

            my $detail = $response -> header('Location') || q{};

            if (!$detail) {
                my $body = $response -> content // q{};

                if ($body =~ /<title[^>]*>(.*?)<\/title>/imsx) {
                    $detail = $1;
                    $detail =~ s/\s+/ /gmsx;
                    $detail =~ s/\A\s+|\s+\z//gmsx;
                }
            }

            if (length($detail) > $TITLE_LIMIT) {
                $detail = substr($detail, 0, $TITLE_LIMIT) . '...';
            }

            push @result, join q{ | }, $host, $status, $server, "len=$length", $detail;

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::HTTP_Fingerprint\n"
                . "=======================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Target to fingerprint\n"
                . "-i, --ip       Pin the connection to this IP, keeping Host and SNI\n"
                . "-f, --follow   Follow redirects instead of reporting them\n"
                . "\n"
                . "Emits one compact line per target: host | status | server | length | title-or-location\n"
                . "When the system resolver cannot answer, it falls back to Recon::DoH_Resolv\n"
                . "and pins the connection to the resolved address.\n\n";
        }

        return 0;
    }
}

1;
