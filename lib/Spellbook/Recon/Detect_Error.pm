package Spellbook::Recon::Detect_Error {
    use strict;
    use warnings;
    use Net::DNS;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_NOT_FOUND => 404;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            $target =~ s/^http(s)?:\/\///msx;

            my $resolv = Net::DNS::Resolver -> new();
            my $reply  = $resolv -> search($target);

            if ($reply) {
                $target = "http://$target";

                foreach my $rr ($reply -> answer()) {
                    if ($rr -> can('cname')) {
                        my $useragent = Spellbook::Core::UserAgent -> new();
                        my $request   = $useragent -> get($target);

                        if ($request -> code() == $HTTP_NOT_FOUND) {
                            push @results, $target;
                        }
                    }
                }
            }

            return @results;
        }

        if ($help) {
            return "\n"
                . "Checker\n"
                . "==============\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Define a target\n\n";
        }
    }
}

1;