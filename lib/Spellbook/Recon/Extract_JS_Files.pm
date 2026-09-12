package Spellbook::Recon::Extract_JS_Files {
    use strict;
    use warnings;
    use URI;
    use Mojo::DOM;
    use Getopt::Long;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

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
            if ($target !~ m{^https?://}ixsm) {
                $target = "https://$target";
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $response   = $user_agent -> get($target);

            if (!$response -> is_success) {
                return 0;
            }

            my $base = URI -> new($response -> base // $target);
            my $dom  = Mojo::DOM -> new($response -> decoded_content // q{});

            # External <script src="..."> references.
            for my $node ($dom -> find('script[src]') -> each) {
                push @result, $node -> attr('src');
            }

            # <div data-script-src="..."> lazy-loader convention.
            for my $node ($dom -> find('[data-script-src]') -> each) {
                push @result, $node -> attr('data-script-src');
            }

            # Inline scripts that name .js paths (protocol/root-relative and chunks).
            for my $node ($dom -> find('script:not([src])') -> each) {
                my $code = $node -> text // q{};
                push @result, ($code =~ m{["'(]((?:https?:)?//[^"'()\s]+?\.js)}gixsm);
                push @result, ($code =~ m{["'(](/[A-Za-z0-9_\-./]+?\.js)}gixsm);
                push @result, ($code =~ m{["']([A-Za-z0-9_\-./]+?\.js)["']}gixsm);
            }

            my @absolute;

            for my $reference (uniq @result) {
                my $resolved = URI -> new_abs($reference, $base);
                my $scheme   = lc($resolved -> scheme // q{});

                if ($scheme ne 'http' && $scheme ne 'https') {
                    next;
                }

                push @absolute, $resolved -> as_string;
            }

            return uniq @absolute;
        }

        if ($help) {
            return "\n"
                . "Recon::Extract_JS_Files\n"
                . "=======================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Fetch a page and extract the JavaScript file URLs it loads\n\n";
        }

        return 0;
    }
}

1;
