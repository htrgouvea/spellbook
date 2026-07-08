package Spellbook::Recon::Extract_JS_Endpoints {
    use strict;
    use warnings;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ /^https?:\/\//xsm) {
                $target = "https://$target";
            }

            my $useragent = Spellbook::Core::UserAgent -> new();
            my $request = $useragent -> get($target);

            if (!$request -> is_success) {
                return 0;
            }

            my $content = $request -> decoded_content // q{};
            my $content_type = $request -> header('Content-Type') // q{};
            my $looks_like_js = 0;

            if ($content_type =~ /javascript|ecmascript|text\/plain/ixsm) {
                $looks_like_js = 1;
            }

            if ($content =~ /\bfunction\b|\bvar\b|\bconst\b|\blet\b|\bimport\b|\bexport\b/xsm) {
                $looks_like_js = 1;
            }

            if (!$looks_like_js) {
                return 0;
            }

            push @result, ($content =~ /https?:\/\/[^\s"'<>\[\]\\]+/gxsm);
            push @result, ($content =~ /["'](\/[[:alnum:]_\-\/.?=&]+)["']/gxsm);
            push @result, ($content =~ /["']([[:alnum:]_\-\/]+[.](?:php|json|js|html|asp|aspx))["']/gxsm);

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Extract_JS_Endpoints\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Fetch a JavaScript resource and extract potential endpoints\n\n";
        }

        return 0;
    }
}

1;
