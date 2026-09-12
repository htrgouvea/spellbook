package Spellbook::Recon::Mass_Resolve {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use Net::DNS;
    use Time::HiRes qw(sleep);
    use Spellbook::Helper::Read_File;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $DNS_TIMEOUT  => 3;
    Readonly my $DNS_RETRIES  => 1;
    Readonly my $DEFAULT_PORT => 53;

    sub _configure {
        my ($resolver) = @_;

        $resolver -> udp_timeout($DNS_TIMEOUT);
        $resolver -> tcp_timeout($DNS_TIMEOUT);
        $resolver -> retry($DNS_RETRIES);
        $resolver -> dnsrch(0);
        $resolver -> defnames(0);

        return $resolver;
    }

    sub _build_resolvers {
        my (@pool) = @_;

        my @resolvers;

        foreach my $entry (@pool) {
            my ($ip, $port) = split /:/msx, $entry, 2;

            if (!$port) {
                $port = $DEFAULT_PORT;
            }

            my $resolver = Net::DNS::Resolver -> new();

            {
                local $SIG{__WARN__} = sub { };
                $resolver -> nameservers($ip);
            }

            $resolver -> port($port);

            push @resolvers, _configure($resolver);
        }

        if (!scalar @resolvers) {
            push @resolvers, _configure(Net::DNS::Resolver -> new());
        }

        return @resolvers;
    }

    sub _resolve_one {
        my ($resolver, $host) = @_;

        my (@cname, @a);

        my $reply = $resolver -> send($host, 'A');

        if (!$reply) {
            return (\@cname, \@a);
        }

        if ($reply -> header() -> rcode() ne 'NOERROR') {
            return (\@cname, \@a);
        }

        foreach my $rr ($reply -> answer()) {
            if ($rr -> type() eq 'CNAME') {
                my $target = $rr -> cname();
                $target =~ s/[.]\z//msx;
                push @cname, $target;
            }

            if ($rr -> type() eq 'A') {
                push @a, $rr -> address();
            }
        }

        return (\@cname, \@a);
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file, $resolvers_file, $json, $pps, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'        => \$help,
            't|target=s'    => \$target,
            'f|file=s'      => \$file,
            'r|resolvers=s' => \$resolvers_file,
            'j|json'        => \$json,
            'pps=i'         => \$pps
        );

        if ($target || $file) {
            if ($file && !-r $file) {
                return @result;
            }

            if ($resolvers_file && !-r $resolvers_file) {
                return @result;
            }

            my @hosts;

            if ($target) {
                push @hosts, $target;
            }

            if ($file) {
                push @hosts, Spellbook::Helper::Read_File -> new(['--file' => $file]);
            }

            my @pool;

            if ($resolvers_file) {
                @pool = Spellbook::Helper::Read_File -> new(['--file' => $resolvers_file]);
            }

            my @resolvers = _build_resolvers(@pool);

            my $delay = 0;

            if ($pps && ($pps > 0)) {
                $delay = 1 / $pps;
            }

            my $encoder = JSON -> new -> canonical;
            my $index   = 0;

            foreach my $host (@hosts) {
                $host =~ s/\A\s+//msx;
                $host =~ s/\s+\z//msx;
                $host =~ s{\Ahttps?://}{}ixsm;
                $host =~ s{/.*\z}{}xsm;

                if ($host eq q{}) {
                    next;
                }

                my $resolver = $resolvers[$index % scalar @resolvers];
                $index++;

                my ($cname, $a) = _resolve_one($resolver, $host);

                if ($delay > 0) {
                    sleep $delay;
                }

                if (!scalar @{$cname} && !scalar @{$a}) {
                    next;
                }

                if ($json) {
                    push @result, $encoder -> encode({
                        domain => $host,
                        CNAME  => $cname,
                        A      => $a
                    });
                    next;
                }

                my @line = ("$host ->");

                foreach my $c (@{$cname}) {
                    push @line, "$c ->";
                }

                foreach my $ip (@{$a}) {
                    push @line, $ip;
                }

                push @result, join q{ }, @line;
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Mass_Resolve\n"
                . "===================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     A single host to resolve\n"
                . "-f, --file       File with hosts to resolve, one per line\n"
                . "-r, --resolvers  File with DNS resolvers (ip or ip:port), rotated across queries\n"
                . "-j, --json       Output as JSON, one object per line\n"
                . "    --pps        Maximum DNS queries per second\n\n";
        }

        return 0;
    }
}

1;
