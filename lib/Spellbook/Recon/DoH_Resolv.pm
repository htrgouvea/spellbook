package Spellbook::Recon::DoH_Resolv {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK => 200;
    Readonly my $TIMEOUT => 15;

    Readonly my %RECORD_TYPES => (
        A     => 1,
        NS    => 2,
        CNAME => 5,
        SOA   => 6,
        MX    => 15,
        TXT   => 16,
        AAAA  => 28,
    );

    Readonly my %PROVIDERS => (
        google     => 'https://dns.google/resolve',
        cloudflare => 'https://cloudflare-dns.com/dns-query',
    );

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $type     = 'A';
        my $provider = 'google';

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'T|type=s'     => \$type,
            'r|resolver=s' => \$provider
        );

        $type     = uc $type;
        $provider = lc $provider;

        if ($target) {
            if ($target =~ /^http(s)?:\/\//msx) {
                $target =~ s/^http(s)?:\/\///msx;
            }

            $target =~ s{/.*\z}{}msx;

            if (!exists $RECORD_TYPES{$type} || !exists $PROVIDERS{$provider}) {
                return @result;
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            $user_agent -> timeout($TIMEOUT);
            $user_agent -> default_headers -> push_header('accept' => 'application/dns-json');

            my $endpoint = $PROVIDERS{$provider} . "?name=$target&type=$type";
            my $request  = $user_agent -> get($endpoint);

            if ($request -> code() != $HTTP_OK) {
                return @result;
            }

            my $content = eval { decode_json($request -> content) };

            if (!$content || (ref $content ne 'HASH')) {
                return @result;
            }

            my $answers = $content -> {Answer};

            if (!$answers || (ref $answers ne 'ARRAY')) {
                return @result;
            }

            foreach my $answer (@{$answers}) {
                if (!defined $answer -> {data}) {
                    next;
                }

                if (defined $answer -> {type} && $answer -> {type} != $RECORD_TYPES{$type}) {
                    next;
                }

                my $data = $answer -> {data};
                $data =~ s/[.]\z//msx;

                push @result, $data;
            }

            my %seen;
            my @unique = grep { !$seen{$_}++ } @result;

            return @unique;
        }

        if ($help) {
            return "\n"
                . "Recon::DoH_Resolv\n"
                . "=================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     Host to resolve\n"
                . "-T, --type       Record type: A, AAAA, CNAME, NS, MX, TXT, SOA (default: A)\n"
                . "-r, --resolver   DoH provider: google or cloudflare (default: google)\n"
                . "\n"
                . "Resolves over HTTPS instead of UDP/53, so it keeps working where the\n"
                . "local resolver filters a zone, rate-limits, or blocks outbound DNS.\n\n";
        }

        return 0;
    }
}

1;
