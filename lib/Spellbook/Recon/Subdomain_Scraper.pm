package Spellbook::Recon::Subdomain_Scraper {
    use strict;
    use warnings;
    use URI;
    use List::MoreUtils qw(uniq);
    use Spellbook::Recon::Extract_Links;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $DOMAIN_SUFFIX_START => -3;
    Readonly my $DOMAIN_SUFFIX_END   => -1;
    Readonly my $DOMAIN_BASE_START   => -2;
    Readonly my $MIN_BR_PARTS        => 3;

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
            if ($target !~ /^http(?:s)?:\/\//msx) {
                $target = "https://$target";
            }

            my $start_uri = URI -> new($target);

            if (!$start_uri -> scheme || $start_uri -> scheme !~ /^https?$/ixsm || !$start_uri -> host) {
                return 0;
            }

            my $get_base_domain = sub {
                my ($host) = @_;
                my @parts = split /[.]/xsm, $host;

                if (@parts < 2) {
                    return $host;
                }

                if (@parts >= $MIN_BR_PARTS && $parts[-1] eq 'br' && $parts[$DOMAIN_BASE_START] =~ /^(com|net|org|gov|mil|edu)$/ixsm) {
                    return join q{.}, @parts[$DOMAIN_SUFFIX_START..$DOMAIN_SUFFIX_END];
                }

                return join q{.}, @parts[$DOMAIN_BASE_START..$DOMAIN_SUFFIX_END];
            };

            my $start_host  = lc $start_uri -> host;
            my $base_domain = $get_base_domain -> ($start_host);

            my @extract_args = ('--target' => $target);

            if ($deep) {
                push @extract_args, '--deep';
            }

            my @links = Spellbook::Recon::Extract_Links -> new(\@extract_args);

            my %found_subdomains;

            if ($start_host =~ /(?:^|[.])\Q$base_domain\E$/ixsm) {
                $found_subdomains{$start_host} = 1;
            }

            for my $link (@links) {
                my $host = lc(URI -> new($link) -> host // q{});

                if (!$host) {
                    next;
                }

                if ($host !~ /(?:^|[.])\Q$base_domain\E$/ixsm) {
                    next;
                }

                $found_subdomains{$host} = 1;
            }

            @result = sort keys %found_subdomains;

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Subdomain_Scraper\n"
                . "=====================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     Scrape a target to find subdomains from its links\n"
                . "-d, --deep       Recursively crawl the target while extracting links\n\n";
        }

        return 0;
    }
}

1;
