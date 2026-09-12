package Spellbook::Recon::Dangling_NS {
    use strict;
    use warnings;
    use Getopt::Long;
    use Net::DNS;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $DNS_TIMEOUT   => 5;
    Readonly my $DNS_RETRIES   => 1;
    Readonly my $PARENT_NS_CAP => 4;

    Readonly my %PROVIDERS => (
        'awsdns'         => 'AWS Route53',
        'ns-cloud-'      => 'Google Cloud DNS',
        'googledomains'  => 'Google Cloud DNS',
        'azure-dns'      => 'Azure DNS',
        'digitalocean'   => 'DigitalOcean',
        'stabletransit'  => 'Rackspace',
        'dnsmadeeasy'    => 'DNS Made Easy',
        'nsone.net'      => 'NS1',
        'cloudns'        => 'ClouDNS',
        'bunny.net'      => 'BunnyDNS',
        'hetzner'        => 'Hetzner',
        'linode'         => 'Linode',
        'vultr'          => 'Vultr',
        'constellix'     => 'Constellix',
        'dnsimple'       => 'DNSimple'
    );

    sub _provider_for {
        my ($ns) = @_;

        foreach my $needle (keys %PROVIDERS) {
            if (index($ns, $needle) >= 0) {
                return $PROVIDERS{$needle};
            }
        }

        return;
    }

    sub _resolver {
        my (@nameservers) = @_;

        my $resolver = Net::DNS::Resolver -> new();

        if (scalar @nameservers) {
            local $SIG{__WARN__} = sub { };
            $resolver -> nameservers(@nameservers);
        }

        $resolver -> udp_timeout($DNS_TIMEOUT);
        $resolver -> tcp_timeout($DNS_TIMEOUT);
        $resolver -> retry($DNS_RETRIES);

        $resolver -> dnsrch(0);
        $resolver -> defnames(0);

        return $resolver;
    }

    sub _delegated_ns {
        my ($target) = @_;

        my @labels = split /[.]/msx, $target;

        if (scalar @labels < 2) {
            return ();
        }

        shift @labels;
        my $parent = join q{.}, @labels;

        my $parent_reply = _resolver() -> send($parent, 'NS');

        if (!$parent_reply) {
            return ();
        }

        my @parent_ns;

        foreach my $rr ($parent_reply -> answer()) {
            if ($rr -> type() eq 'NS') {
                push @parent_ns, $rr -> nsdname();
            }
        }

        if (!scalar @parent_ns) {
            return ();
        }

        if (scalar @parent_ns > $PARENT_NS_CAP) {
            @parent_ns = @parent_ns[0 .. $PARENT_NS_CAP - 1];
        }

        my $referral = _resolver(@parent_ns);
        $referral -> recurse(0);

        my $reply = $referral -> send($target, 'NS');

        if (!$reply) {
            return ();
        }

        my (%seen, @delegated);

        foreach my $rr ($reply -> answer(), $reply -> authority()) {
            if ($rr -> type() eq 'NS') {
                my $ns = lc $rr -> nsdname();

                if (!$seen{$ns}) {
                    $seen{$ns} = 1;
                    push @delegated, $ns;
                }
            }
        }

        return @delegated;
    }

    sub _resolves {
        my ($host) = @_;

        my $reply = _resolver() -> send($host, 'A');

        if ($reply && scalar $reply -> answer()) {
            return 1;
        }

        return 0;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            $target =~ s{\Ahttps?://}{}ixsm;
            $target =~ s{/.*\z}{}xsm;
            $target = lc $target;

            my @nameservers = _delegated_ns($target);

            foreach my $ns (@nameservers) {
                my $provider = _provider_for($ns);

                if (!$provider) {
                    next;
                }

                my $probe = _resolver($ns);
                $probe -> recurse(0);

                my $reply = $probe -> send($target, 'SOA');

                if ($reply) {
                    my $rcode = $reply -> header() -> rcode();

                    if (($rcode eq 'REFUSED') || ($rcode eq 'SERVFAIL')) {
                        push @results, join q{ | }, $target, "ns=$ns",
                            "provider=$provider", "rcode=$rcode",
                            'takeover: possible (dangling delegation)';
                    }

                    next;
                }

                if (!_resolves($ns)) {
                    push @results, join q{ | }, $target, "ns=$ns",
                        "provider=$provider", 'rcode=NXDOMAIN',
                        'takeover: possible (nameserver hostname unresolvable)';
                }
            }

            return @results;
        }

        if ($help) {
            return "\n"
                . "Recon::Dangling_NS\n"
                . "==================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Domain to check for a dangling NS delegation to a cloud DNS provider\n\n";
        }

        return 0;
    }
}

1;
