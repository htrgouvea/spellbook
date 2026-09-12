package Spellbook::Recon::Passive_Links {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.2';

    use Readonly;
    Readonly my $HTTP_OK      => 200;
    Readonly my $HTTP_TIMEOUT => 60;
    Readonly my $MAX_RETRIES  => 3;
    Readonly my $PAGE_SIZE    => 100;
    Readonly my $MAX_PAGES    => 100;

    sub _fetch {
        my ($user_agent, $url) = @_;

        foreach my $attempt (1 .. $MAX_RETRIES) {
            my $request = $user_agent -> get($url);

            if ($request -> code() != $HTTP_OK) {
                next;
            }

            if ($request -> header('Client-Aborted')) {
                next;
            }

            return $request;
        }

        return undef;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            my $user_agent = Spellbook::Core::UserAgent -> new();

            $user_agent -> timeout($HTTP_TIMEOUT);

            foreach my $page (1 .. $MAX_PAGES) {
                my $otx_endpoint = "https://otx.alienvault.com/api/v1/indicators/domain/$target/url_list?limit=$PAGE_SIZE&page=$page";
                my $otx_request  = _fetch($user_agent, $otx_endpoint);

                if (!$otx_request) {
                    last;
                }

                my $otx_content = eval { decode_json($otx_request -> content()) };

                if (ref $otx_content ne 'HASH') {
                    last;
                }

                my $otx_url_list = $otx_content -> {url_list} // [];

                foreach my $entry (@{$otx_url_list}) {
                    my $url = $entry -> {url};

                    if ($url) {
                        push @result, $url;
                    }
                }

                if (!$otx_content -> {has_next}) {
                    last;
                }
            }

            foreach my $page (0 .. $MAX_PAGES - 1) {
                my $wayback_endpoint = "https://web.archive.org/cdx/search/cdx?url=$target/*&output=json&collapse=urlkey&fl=original&pageSize=$PAGE_SIZE&page=$page";
                my $wayback_request  = _fetch($user_agent, $wayback_endpoint);

                if (!$wayback_request) {
                    last;
                }

                if ($wayback_request -> content() eq '[]') {
                    last;
                }

                my $wayback_content = eval { decode_json($wayback_request -> content()) };

                if (ref $wayback_content ne 'ARRAY') {
                    last;
                }

                if (!scalar @{$wayback_content}) {
                    last;
                }

                my $found = 0;

                foreach my $fullurl (@{$wayback_content}) {
                    if ($fullurl -> [0] ne 'original') {
                        push @result, $fullurl -> [0];
                        $found++;
                    }
                }

                if (!$found) {
                    last;
                }
            }

            my $index = 'CC-MAIN-2024-10';
            my $index_request = _fetch($user_agent, 'https://index.commoncrawl.org/collinfo.json');

            if ($index_request) {
                my $index_content = eval { decode_json($index_request -> content()) };

                if ((ref $index_content eq 'ARRAY') && (scalar @{$index_content} > 0)) {
                    my $latest_index = $index_content -> [0] -> {id};

                    if ($latest_index) {
                        $index = $latest_index;
                    }
                }
            }

            my $pages = 0;
            my $pagination_endpoint = "https://index.commoncrawl.org/$index-index?url=$target/*&output=json&fl=url&showNumPages=true";
            my $pagination_request  = _fetch($user_agent, $pagination_endpoint);

            if ($pagination_request) {
                my $pagination = eval { decode_json($pagination_request -> content()) };

                if ((ref $pagination eq 'HASH') && ($pagination -> {pages})) {
                    $pages = $pagination -> {pages};
                }
            }

            if ($pages > $MAX_PAGES) {
                $pages = $MAX_PAGES;
            }

            foreach my $page (0 .. $pages - 1) {
                my $common_crawl_endpoint = "https://index.commoncrawl.org/$index-index?url=$target/*&output=json&fl=url&page=$page";
                my $common_crawl_request  = _fetch($user_agent, $common_crawl_endpoint);

                if (!$common_crawl_request) {
                    next;
                }

                my $common_crawl_content = $common_crawl_request -> content();

                foreach my $line (split /\n/msx, $common_crawl_content) {
                    if ($line) {
                        my $entry = eval { decode_json($line) };

                        if (ref $entry ne 'HASH') {
                            next;
                        }

                        my $url = $entry -> {url};

                        if ($url) {
                            push @result, $url;
                        }
                    }
                }
            }

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Passive_Links\n"
                . "====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Define a domain to find known URLs\n";
        }

        return 0;
    }
}

1;
