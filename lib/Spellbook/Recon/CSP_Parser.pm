package Spellbook::Recon::CSP_Parser {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use Mojo::DOM;
    use URI::Escape qw(uri_escape);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_TIMEOUT => 15;

    sub _parse_csp {
        my ($csp, $csp_object) = @_;

        if (!defined $csp) {
            return;
        }

        $csp =~ s/;[ ]/;/gmsx;

        foreach my $rule (split /;/msx, $csp) {
            $rule =~ s/\A\s+//msx;
            $rule =~ s/\s+\z//msx;

            if ($rule eq q{}) {
                next;
            }

            my @tokens    = split /\s+/msx, $rule;
            my $directive = shift @tokens;

            $csp_object -> {$directive} = [@tokens];
        }

        return;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $google);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'g|google'   => \$google
        );

        if ($target) {
            if ($target !~ m{\Ahttps?://}ixsm) {
                $target = "https://$target";
            }

            my $csp_object = {
                type     => 'ServiceDescriptor',
                name     => 'httpCsp',
                location => 'Header'
            };

            my $user_agent = Spellbook::Core::UserAgent -> new();

            $user_agent -> timeout($HTTP_TIMEOUT);

            my $response = $user_agent -> get($target);

            if ($response -> is_success()) {
                _parse_csp(scalar $response -> header('Content-Security-Policy'), $csp_object);
            }

            if ($google) {
                my $endpoint  = 'https://csp-evaluator.withgoogle.com/getCSP?url=' . uri_escape($target);
                my $evaluator = $user_agent -> post($endpoint);

                if ($evaluator -> is_success()) {
                    my $data = eval { decode_json($evaluator -> content()) };

                    if ((ref $data eq 'HASH') && (($data -> {status} // q{}) eq 'ok')) {
                        _parse_csp($data -> {csp}, $csp_object);
                    }
                }
            }

            if ($response -> is_success()) {
                my $dom = Mojo::DOM -> new($response -> decoded_content // q{});

                for my $node ($dom -> find('meta[http-equiv]') -> each) {
                    my $equiv = lc($node -> attr('http-equiv') // q{});

                    if ($equiv eq 'content-security-policy') {
                        _parse_csp($node -> attr('content'), $csp_object);
                    }
                }
            }

            my $json = JSON -> new -> utf8 -> pretty -> canonical;

            return $json -> encode($csp_object);
        }

        if ($help) {
            return "\n"
                . "Recon::CSP_Parser\n"
                . "=================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Domain or URL to retrieve and parse the CSP from\n"
                . "-g, --google   Also query Google's csp-evaluator (sends the URL to Google)\n\n";
        }

        return 0;
    }
}

1;
