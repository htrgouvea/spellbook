package Spellbook::Recon::HaveBeenPwned {
    use strict;
    use warnings;
    use JSON;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;

    # THIS IS A DRAFT MODULE

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            my $api_key   = Spellbook::Core::Credentials -> new(["--platform" => "hibp"]);
            my $useragent = LWP::UserAgent -> new();
            $useragent    -> default_header("hibp-api-key" => $api_key);
            my $request   = $useragent -> get("https://haveibeenpwned.com/api/v3/breachedaccount/$target");

            if ($request -> code() == 200) {
                my $data = decode_json($request -> content());

                return $data;
            }

            return $request -> code();
        }

        if ($help) {
            return "
                \rRecon::HaveBeenPwned
                \r====================
                \r-h, --help     See this menu
                \r-e, --target   Define an e-mail address as a target\n\n";
        }

        return 0;
    }
}

1;