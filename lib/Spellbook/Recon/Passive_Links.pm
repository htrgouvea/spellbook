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
            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $otxEndpoint = "https://otx.alienvault.com/api/v1/indicators/domain/$target/url_list?limit=500&page=1";
            my $otxRequest  = $userAgent -> get($otxEndpoint);

            if ($otxRequest -> code() == 200) {
                my $otxContent = decode_json($otxRequest -> content);
                my $otxUrlList = $otxContent -> {url_list};

                if ($otxUrlList) {
                    foreach my $entry (@{$otxUrlList}) {
                        my $url = $entry -> {url};

                        if ($url) {
                            push @result, $url;
                        }
                    }
                }
            }

            my $waybackEndpoint = "https://web.archive.org/cdx/search/cdx?url=$target/*&output=json&collapse=urlkey";
            my $waybackRequest  = $userAgent -> get($waybackEndpoint);

            if (($waybackRequest -> code() == 200) && ($waybackRequest -> content ne '[]')) {
                my $waybackContent = decode_json($waybackRequest -> content);

                foreach my $fullurl (@{$waybackContent}) {
                    if ($fullurl -> [2] ne 'original') {
                        push @result, $fullurl -> [2];
                    }
                }
            }

            my $index = 'CC-MAIN-2024-10';
            my $indexRequest = $userAgent -> get('https://index.commoncrawl.org/collinfo.json');

            if ($indexRequest -> code() == 200) {
                my $indexContent = decode_json($indexRequest -> content);

                if ((ref $indexContent eq 'ARRAY') && (@{$indexContent} > 0)) {
                    my $latestIndex = $indexContent -> [0] -> {id};

                    if ($latestIndex) {
                        $index = $latestIndex;
                    }
                }
            }

            my $commonCrawlEndpoint = "https://index.commoncrawl.org/$index-index?url=$target/*&output=json";
            my $commonCrawlRequest  = $userAgent -> get($commonCrawlEndpoint);

            if ($commonCrawlRequest -> code() == 200) {
                my $commonCrawlContent = $commonCrawlRequest -> content;

                foreach my $line (split /\n/msx, $commonCrawlContent) {
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
