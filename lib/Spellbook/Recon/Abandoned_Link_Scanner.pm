package Spellbook::Recon::Abandoned_Link_Scanner {
    use strict;
    use warnings;
    use Getopt::Long;
    use Net::DNS;
    use Spellbook::Core::UserAgent;
    use URI;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $MAX_URL_LENGTH => 2000;
    Readonly my $MAX_CNAME_DEPTH => 10;
    Readonly my $HTTP_MOVED_PERMANENTLY => 301;
    Readonly my $HTTP_INTERNAL_SERVER_ERROR => 500;

    ## no critic (Subroutines::ProhibitExcessComplexity)
    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $domain, $include_base, $limit, @results);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'         => \$help,
            't|target=s'     => \$target,
            'd|domain=s'     => \$domain,
            'b|include-base' => \$include_base,
            'l|limit=i'      => \$limit,
        );

        if ($help) {
            return "\n"
                . "Recon::Abandoned_Link_Scanner\n"
                . "=============================\n"
                . "-h, --help           See this menu\n"
                . "-t, --target         Fetch a page and check linked domains for takeover signals\n"
                . "-d, --domain         Check a single domain directly\n"
                . "-b, --include-base   Also check the target page hostname\n"
                . "-l, --limit          Limit the number of linked domains checked\n\n";
        }

        # Fingerprint coverage adapted from Blaze Information Security's
        # Apache-2.0 abandoned-link-scanner Burp extension.
        my @fingerprints = (
            {
                service => 'AWS_S3',
                cnames => ['s3.amazonaws.com'],
                patterns => ['NoSuchBucket', 'The specified bucket does not exist'],
                cname_takeover_signal => 1,
            },
            {
                service => 'AWS_ELASTIC_BEANSTALK',
                cnames => ['elasticbeanstalk.com'],
                patterns => ['NXDOMAIN'],
            },
            {
                service => 'AZURE',
                cnames => [
                    'azure-api.net',
                    'azurecontainer.io',
                    'azurecr.io',
                    'azureedge.net',
                    'azurehdinsight.net',
                    'azurewebsites.net',
                    'blob.core.windows.net',
                    'cloudapp.azure.com',
                    'cloudapp.net',
                    'database.windows.net',
                    'redis.cache.windows.net',
                    'search.windows.net',
                    'servicebus.windows.net',
                    'visualstudio.com',
                ],
                patterns => [
                    'The specified resource does not exist',
                    'The resource you are looking for has been removed',
                ],
                cname_takeover_signal => 1,
            },
            {
                service => 'GITHUB_PAGES',
                cnames => ['github.io', 'github.com'],
                patterns => [
                    q{There isn't a GitHub Pages site here},
                    q{Repository not found},
                ],
            },
            {
                service => 'HEROKU',
                cnames => ['herokuapp.com', 'herokudns.com'],
                patterns => [
                    q{No such app},
                    q{herokucdn.com/error-pages/no-such-app.html},
                ],
            },
            {
                service => 'SURGE_SH',
                cnames => ['surge.sh', 'na-west1.surge.sh'],
                patterns => ['project not found'],
            },
            {
                service => 'READTHEDOCS',
                cnames => ['readthedocs.io'],
                patterns => [
                    'The link you have followed or the URL that you entered does not exist',
                ],
            },
            {
                service => 'NGROK',
                cnames => ['ngrok.io'],
                patterns => ['ERR_NGROK_3200'],
            },
            {
                service => 'WORDPRESS',
                cnames => ['wordpress.com'],
                patterns => [q{Do you want to register .*\.wordpress\.com}],
            },
            {
                service => 'BITBUCKET',
                cnames => ['bitbucket.io'],
                patterns => ['Repository not found'],
            },
            {
                service => 'DISCOURSE',
                cnames => ['trydiscourse.com'],
                patterns => ['NXDOMAIN'],
            },
            {
                service => 'HELPRACE',
                cnames => ['helprace.com'],
                patterns => [],
                statuses => [$HTTP_MOVED_PERMANENTLY],
            },
            {
                service => 'LAUNCHROCK',
                cnames => ['launchrock.com'],
                patterns => [],
                statuses => [$HTTP_INTERNAL_SERVER_ERROR],
            },
            {
                service => 'AGILE_CRM',
                cnames => ['agilecrm.com'],
                patterns => ['Sorry, this page is no longer available'],
            },
            {
                service => 'AIREE',
                cnames => ['airee.ru'],
                patterns => ['Error 402. Airee.ru Service Not Paid'],
            },
            {
                service => 'ANIMA',
                cnames => ['animaapp.io'],
                patterns => ['The page you were looking for does not exist'],
            },
            {
                service => 'CANNY',
                cnames => ['canny.io'],
                patterns => ['Company Not Found', 'There is no such company'],
            },
            {
                service => 'GEMFURY',
                cnames => ['furyns.com'],
                patterns => ['404: This page could not be found'],
            },
            {
                service => 'GHOST',
                cnames => ['ghost.io'],
                patterns => ['Site unavailable', 'Failed to resolve DNS path for this host'],
            },
            {
                service => 'HATENABLOG',
                cnames => ['hatenablog.com'],
                patterns => ['404 Blog is not found'],
            },
            {
                service => 'HELPJUICE',
                cnames => ['helpjuice.com'],
                patterns => [q{We could not find what you're looking for}],
            },
            {
                service => 'HELPSCOUT',
                cnames => ['helpscoutdocs.com'],
                patterns => ['No settings were found for this company'],
            },
            {
                service => 'JETBRAINS',
                cnames => ['youtrack.cloud'],
                patterns => ['is not a registered InCloud YouTrack'],
            },
            {
                service => 'PANTHEON',
                cnames => ['pantheonsite.io'],
                patterns => ['404 error unknown site'],
            },
            {
                service => 'PINGDOM',
                cnames => ['stats.pingdom.com'],
                patterns => [q{Sorry, couldn't find the status page}],
            },
            {
                service => 'README_IO',
                cnames => ['readme.io'],
                patterns => ['The creators of this project are still working on making everything perfect'],
            },
            {
                service => 'SHORT_IO',
                cnames => ['short.io'],
                patterns => ['Link does not exist'],
            },
            {
                service => 'STRIKINGLY',
                cnames => ['s.strikinglydns.com'],
                patterns => ['PAGE NOT FOUND'],
            },
            {
                service => 'SURVEYSPARROW',
                cnames => ['surveysparrow.com'],
                patterns => ['Account not found'],
            },
            {
                service => 'UBERFLIP',
                cnames => ['read.uberflip.com'],
                patterns => [q{The URL you've accessed does not provide a hub}],
            },
            {
                service => 'UPTIMEROBOT',
                cnames => ['stats.uptimerobot.com'],
                patterns => ['page not found'],
            },
            {
                service => 'WORKSITES',
                cnames => ['worksites.net'],
                patterns => [q{website you&rsquo;re looking for doesn&rsquo;t exist}],
            },
        );

        my @domains;

        if ($domain) {
            push @domains, $domain;
        }

        if ($target) {
            if ($target !~ m{^https?://}ixsm) {
                $target = "https://$target";
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $response = $user_agent -> get($target);
            my $base_uri = URI -> new($target);

            if ($response -> is_success()) {
                my $content_type = $response -> header('Content-Type') // q{};

                if ($content_type =~ m{text/html|application/xhtml[+]xml}ixsm) {
                    my $html = $response -> decoded_content();
                    my @link_patterns = (
                        qr{<iframe[^>]+src=["']([^"']+)["']}ixsm,
                        qr{<script[^>]+src=["']([^"']+)["']}ixsm,
                        qr{<img[^>]+src=["']([^"']+)["']}ixsm,
                        qr{<audio[^>]+src=["']([^"']+)["']}ixsm,
                        qr{<video[^>]+src=["']([^"']+)["']}ixsm,
                        qr{<source[^>]+src=["']([^"']+)["']}ixsm,
                        qr{<link[^>]+href=["']([^"']+)["']}ixsm,
                        qr{<a[^>]+href=["']([^"']+)["']}ixsm,
                        qr{<object[^>]+data=["']([^"']+)["']}ixsm,
                        qr{<form[^>]+action=["']([^"']+)["']}ixsm,
                        qr{<area[^>]+action=["']([^"']+)["']}ixsm,
                        qr{<video[^>]+poster=["']([^"']+)["']}ixsm,
                    );

                    while ($html =~ m{mailto:([^"'<>\s]+)}igxsm) {
                        my @email_parts = split m{@}xsm, $1;
                        my $email_domain = pop @email_parts;

                        if ($email_domain) {
                            push @domains, $email_domain;
                        }
                    }

                    for my $link_pattern (@link_patterns) {
                        while ($html =~ m{$link_pattern}gxsm) {
                            my $value = $1;

                            next if !$value;
                            next if length($value) > $MAX_URL_LENGTH;

                            my $uri = URI -> new_abs($value, $base_uri);
                            my $scheme = $uri -> scheme() // q{};

                            next if $scheme !~ m{^https?$}ixsm;

                            push @domains, $uri -> host();
                        }
                    }
                }
            }

            if ($include_base && $base_uri -> host()) {
                push @domains, $base_uri -> host();
            }
        }

        if (!@domains) {
            return 0;
        }

        my %seen_domains;
        for my $index (0 .. $#domains) {
            my $normalized_domain = $domains[$index];
            $normalized_domain =~ s{^https?://}{}ixsm;
            $normalized_domain =~ s{/.*$}{}xsm;
            $normalized_domain =~ s{:\d+$}{}xsm;
            $domains[$index] = lc $normalized_domain;
        }

        @domains = grep {
            $_
            && !m{\A(?:\d{1,3}[.]){3}\d{1,3}\z}xsm
            && !$seen_domains{$_}++
        } @domains;

        if ($limit && scalar @domains > $limit) {
            @domains = @domains[0 .. $limit - 1];
        }

        for my $linked_domain (@domains) {
            my $resolver = Net::DNS::Resolver -> new();
            my (@cnames, %seen_cnames);
            my $current_domain = $linked_domain;

            for (1 .. $MAX_CNAME_DEPTH) {
                my $cname_reply = $resolver -> search($current_domain, 'CNAME');

                if (!$cname_reply) {
                    last;
                }

                my @answers = grep { $_ -> type() eq 'CNAME' } $cname_reply -> answer();

                if (!@answers) {
                    last;
                }

                my $cname = lc $answers[0] -> cname();
                $cname =~ s{[.]$}{}xsm;

                if ($seen_cnames{$cname}) {
                    last;
                }

                $seen_cnames{$cname} = 1;
                push @cnames, $cname;
                $current_domain = $cname;
            }

            my $dns_reply = $resolver -> search($linked_domain, 'A')
                || $resolver -> search($linked_domain, 'AAAA');

            if (!$dns_reply && $resolver -> errorstring() =~ m{NXDOMAIN}ixsm) {
                push @results, join "\t",
                    $linked_domain,
                    'DNS',
                    'manual-verification-required',
                    'Domain returns NXDOMAIN';
                next;
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            $user_agent -> max_redirect(0);

            my $domain_response = $user_agent -> get("https://$linked_domain/");

            if (!$domain_response || !$domain_response -> code()) {
                $domain_response = $user_agent -> get("http://$linked_domain/");
            }

            my $body = $domain_response ? $domain_response -> decoded_content() : q{};
            my $status = $domain_response ? $domain_response -> code() : 0;
            my $found;

            for my $fingerprint (@fingerprints) {
                my ($cname_match, $body_match, $status_match);

                for my $needle (@{$fingerprint -> {cnames} // []}) {
                    for my $cname (@cnames) {
                        if ($cname =~ m{\Q$needle\E}ixsm) {
                            $cname_match = $cname;
                            last;
                        }
                    }

                    if ($cname_match) {
                        last;
                    }
                }

                for my $pattern (@{$fingerprint -> {patterns} // []}) {
                    if ($body && $body =~ m{$pattern}ixsm) {
                        $body_match = $pattern;
                        last;
                    }
                }

                for my $expected_status (@{$fingerprint -> {statuses} // []}) {
                    if ($status && $status == $expected_status) {
                        $status_match = 1;
                        last;
                    }
                }

                if ($body_match || ($status_match && $cname_match)) {
                    push @results, join "\t",
                        $linked_domain,
                        $fingerprint -> {service},
                        'probable',
                        $body_match || "HTTP status $status with matching CNAME";
                    $found = 1;
                    last;
                }

                if ($cname_match && $fingerprint -> {cname_takeover_signal}) {
                    push @results, join "\t",
                        $linked_domain,
                        $fingerprint -> {service},
                        'manual-verification-required',
                        "CNAME matches $cname_match";
                    $found = 1;
                    last;
                }
            }

            if (!$found && !$domain_response) {
                push @results, join "\t",
                    $linked_domain,
                    'HTTP',
                    'manual-verification-required',
                    'Connection failed';
            }
        }

        return @results;
    }
}

1;
