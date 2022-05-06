package Spellbook::Helper::HackerOne_Scraper {
    use strict;
    use warnings;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;
    
    sub new {
        my ($self, $parameters)= @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=i" => \$target
        );

        my $token = Spellbook::Core::Credentials -> new(["--platform" => "hackerone"]);

        if ($token) {
            my $userAgent = LWP::UserAgent -> new();
            
            # curl "https://api.hackerone.com/v1/me/programs" -X GET -u "<YOUR_API_USERNAME>:<YOUR_API_TOKEN>" -H 'Accept: application/json'
            # curl "https://api.hackerone.com/v1/programs/{id}/structured_scopes" -X GET -u "<YOUR_API_USERNAME>:<YOUR_API_TOKEN>" -H 'Accept: application/json'
        }

        if ($help) {
            return "
                \rHelper::HackerOne_Scraper
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Program ID from HackerOne\n\n";
        }

        return 0;
    }
}   

1;