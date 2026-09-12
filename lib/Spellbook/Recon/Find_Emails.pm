package Spellbook::Recon::Find_Emails {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use Spellbook::Core::UserAgent;
    use Spellbook::Core::Credentials;

    our $VERSION = '0.0.1';

    use Readonly;
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
            my $api_key    = Spellbook::Core::Credentials -> new (['--platform' => 'hunter']);
            my $endpoint  = "https://api.hunter.io/v2/domain-search?domain=$target&api_key=$api_key";
            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $request   = $user_agent -> get($endpoint);
            my $http_code  = $request -> code();

            if ($http_code == $HTTP_OK) {
                my $content = decode_json($request -> content);

                foreach my $email (@{$content -> {data} -> {emails}}) {
                    push @result, $email -> {'value'};
                }

                return @result;
            }
        }

        if ($help) {
            return "\n"
                . "Recon::Find_Emails\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Define a domain to find emails\n";
        }

        return 0;
    }
}

1;