package Spellbook::Recon::URLScan_Links {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;
    use Spellbook::Core::Credentials;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK          => 200;
    Readonly my $HTTP_RATELIMITED => 429;
    Readonly my $HTTP_TIMEOUT     => 60;
    Readonly my $MAX_RETRIES      => 3;
    Readonly my $PAGE_SIZE        => 100;
    Readonly my $MAX_PAGES        => 100;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $subs, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            's|subs'     => \$subs
        );

        if ($target) {
            $target =~ s{\Ahttps?://}{}ixsm;
            $target =~ s{/.*\z}{}xsm;

            my $user_agent = Spellbook::Core::UserAgent -> new();

            $user_agent -> timeout($HTTP_TIMEOUT);

            my $api_key = Spellbook::Core::Credentials -> new(['--platform' => 'urlscan']);
            my @headers;

            if ($api_key) {
                push @headers, 'API-Key', $api_key;
            }

            my $search_after = q{};

            foreach my $page (1 .. $MAX_PAGES) {
                my $endpoint = "https://urlscan.io/api/v1/search/?q=domain:$target&size=$PAGE_SIZE";

                if ($search_after ne q{}) {
                    $endpoint .= "&search_after=$search_after";
                }

                my $content;

                foreach my $attempt (1 .. $MAX_RETRIES) {
                    my $request = $user_agent -> get($endpoint, @headers);

                    if ($request -> code() == $HTTP_RATELIMITED) {
                        return uniq @result;
                    }

                    if ($request -> code() != $HTTP_OK) {
                        next;
                    }

                    if ($request -> header('Client-Aborted')) {
                        next;
                    }

                    my $decoded = eval { decode_json($request -> content()) };

                    if (ref $decoded eq 'HASH') {
                        $content = $decoded;
                        last;
                    }
                }

                if (ref $content ne 'HASH') {
                    last;
                }

                my $results = $content -> {results} // [];

                if (!scalar @{$results}) {
                    last;
                }

                foreach my $item (@{$results}) {
                    my $page_data = $item -> {page} // {};
                    my $domain    = $page_data -> {domain} // q{};
                    my $url       = $page_data -> {url};

                    if (!$url) {
                        next;
                    }

                    my $matches = 0;

                    if ($domain eq $target) {
                        $matches = 1;
                    }

                    if ($subs && ($domain =~ /\.\Q$target\E\z/msx)) {
                        $matches = 1;
                    }

                    if ($matches) {
                        push @result, $url;
                    }
                }

                if (!$content -> {has_more}) {
                    last;
                }

                my $last = $results -> [-1];
                my $sort = $last -> {sort} // [];

                if (!scalar @{$sort}) {
                    last;
                }

                $search_after = join q{,}, @{$sort};
            }

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::URLScan_Links\n"
                . "====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Domain to fetch known URLs from URLScan.io\n"
                . "-s, --subs     Include subdomains of the target domain\n\n";
        }

        return 0;
    }
}

1;
