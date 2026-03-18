package Spellbook::Recon::Passive_Links {
    use strict;
    use warnings;
    use JSON;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $otx_endpoint = "https://otx.alienvault.com/api/v1/indicators/domain/$target/url_list?limit=500&page=1";
            my $otx_request  = $user_agent -> get($otx_endpoint);

            if ($otx_request -> code() == 200) {
                my $otx_content = decode_json($otx_request -> content);
                my $otx_url_list = $otx_content -> {url_list};

                if ($otx_url_list) {
                    foreach my $entry (@{$otx_url_list}) {
                        my $url = $entry -> {url};

                        if ($url) {
                            push @result, $url;
                        }
                    }
                }
            }

            my $wayback_endpoint = "https://web.archive.org/cdx/search/cdx?url=$target/*&output=json&collapse=urlkey";
            my $wayback_request  = $user_agent -> get($wayback_endpoint);

            if (($wayback_request -> code() == 200) && ($wayback_request -> content ne '[]')) {
                my $wayback_content = decode_json($wayback_request -> content);

                foreach my $fullurl (@{$wayback_content}) {
                    if ($fullurl -> [2] ne 'original') {
                        push @result, $fullurl -> [2];
                    }
                }
            }

            my $index = 'CC-MAIN-2024-10';
            my $index_request = $user_agent -> get('https://index.commoncrawl.org/collinfo.json');

            if ($index_request -> code() == 200) {
                my $index_content = decode_json($index_request -> content);

                if ((ref $index_content eq 'ARRAY') && (@{$index_content} > 0)) {
                    my $latest_index = $index_content -> [0] -> {id};

                    if ($latest_index) {
                        $index = $latest_index;
                    }
                }
            }

            my $common_crawl_endpoint = "https://index.commoncrawl.org/$index-index?url=$target/*&output=json";
            my $common_crawl_request  = $user_agent -> get($common_crawl_endpoint);

            if ($common_crawl_request -> code() == 200) {
                my $common_crawl_content = $common_crawl_request -> content;

                foreach my $line (split /\n/msx, $common_crawl_content) {
                    if ($line) {
                        my $entry = decode_json($line);
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
            return "
                \rRecon::Passive_Links
                \r====================
                \r-h, --help     See this menu
                \r-t, --target   Define a domain to find known URLs\n";
        }

        return 0;
    }
}

1;
