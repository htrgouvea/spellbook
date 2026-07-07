package Spellbook::Recon::Extract_Links {
    use strict;
    use warnings;
    use URI;
    use Try::Tiny;
    use WWW::Mechanize;
    use List::MoreUtils qw(uniq);

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $deep, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'd|deep'     => \$deep
        );

        if ($target) {
            my $normalized_target = $target;
            my $mech = WWW::Mechanize -> new (
                autocheck => 0,
                ssl_opts => {verify_hostname => 0}
            );

            if ($normalized_target !~ /^http(?:s)?:\/\//msx) {
                $normalized_target = "https://$normalized_target";
            }

            if ($normalized_target =~ /\/$/msx) {
                chop $normalized_target;
            }

            my %seen;
            my $collect_links;
            $collect_links = sub {
                my (%args) = @_;
                my $root_url = $args{root_url};
                my $current_url = $args{url};
                my $should_recurse = $args{deep};
                my $seen_urls = $args{seen};
                my $root_host = lc(URI -> new($root_url) -> host // q{});
                my @collected_links;

                if ($seen_urls -> {$current_url}) {
                    return ();
                }

                $seen_urls -> {$current_url} = 1;
                my $response = $mech -> get($current_url);

                if (!$response) {
                    return ();
                }

                if (!$response -> is_success) {
                    return ();
                }

                my @page_links = $mech -> links();

                for my $link (@page_links) {
                    my $absolute = $link -> url_abs();

                    if (!$absolute) {
                        next;
                    }

                    my $scheme = lc($absolute -> scheme // q{});

                    if ($scheme ne 'http' && $scheme ne 'https') {
                        next;
                    }

                    my $absolute_url = $absolute -> as_string;
                    push @collected_links, $absolute_url;

                    my $host = lc($absolute -> host // q{});

                    if ($should_recurse && $host eq $root_host) {
                        try {
                            push @collected_links, $collect_links -> (
                                root_url => $root_url,
                                url => $absolute_url,
                                deep => $should_recurse,
                                seen => $seen_urls
                            );
                        } catch {
                        };
                    }
                }

                return @collected_links;
            };

            @result = $collect_links -> (
                root_url => $normalized_target,
                url => $normalized_target,
                deep => $deep,
                seen => \%seen
            );

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Extrac_Links\n"
                . "=====================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     Define a web page to extract all links\n"
                . "-d, --deep       Draft recursive function\n\n";
        }

        return 0;
    }

}

1;
