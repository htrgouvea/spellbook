package Spellbook::Recon::Extract_Links {
    use strict;
    use warnings;
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
                ssl_opts => { verify_hostname => 0 }
            );

            if ($normalized_target !~ /^http(s)?:\/\//msx) {
                $normalized_target = "https://$normalized_target";
            }

            if ($normalized_target =~ /\/$/msx) {
                chop($normalized_target);
            }

            my %seen;
            my $collect_links;
            $collect_links = sub {
                my (%args) = @_;
                my $root_url = $args{root_url};
                my $current_url = $args{url};
                my $should_recurse = $args{deep};
                my $seen_urls = $args{seen};
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
                    my $url = $link -> url();

                    if ($url && $url !~ m/#/msx && $url !~ /^http(s)?:\/\//msx) {
                        if ($url !~ /^\//msx) {
                            $url = '/' . $url;
                        }

                        my $absolute_url = $root_url . $url;
                        push @collected_links, $absolute_url;

                        if ($should_recurse) {
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
            return "
                \rRecon::Extrac_Links
                \r=====================
                \r-h, --help       See this menu
                \r-t, --target     Define a web page to extract all links
                \r-d, --deep       Draft recursive function\n\n";
        }

        return 0;
    }

}

1;
