package Spellbook::Recon::Entra_SSO_Apps {
    use strict;
    use warnings;
    use JSON;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;
    use Spellbook::Core::Credentials;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK      => 200;
    Readonly my $TENANT_INDEX => 3;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            $target =~ s{\Ahttps?://}{}ixsm;
            $target =~ s{/.*\z}{}xsm;

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $config = $user_agent -> get("https://login.microsoftonline.com/$target/.well-known/openid-configuration");

            if ($config -> code() != $HTTP_OK) {
                return @result;
            }

            my $config_data = decode_json($config -> content());
            my $issuer = $config_data -> {issuer};

            if (!$issuer) {
                return @result;
            }

            my $tenant_id = (split m{/}xsm, $issuer)[$TENANT_INDEX];

            if (!$tenant_id) {
                return @result;
            }

            my $api_key = Spellbook::Core::Credentials -> new(['--platform' => 'urlscan']);
            my @headers;

            if ($api_key) {
                push @headers, 'api-key', $api_key;
            }

            my $search = $user_agent -> get("https://urlscan.io/api/v1/search?q=page.url:*$tenant_id*", @headers);

            if ($search -> code() != $HTTP_OK) {
                return @result;
            }

            my $search_data = decode_json($search -> content());

            foreach my $item (@{$search_data -> {results} // []}) {
                my $url = $item -> {task} -> {url};

                if ($url) {
                    push @result, $url;
                }
            }

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Entra_SSO_Apps\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Organization domain; finds its Entra ID tenant apps via URLScan\n\n";
        }

        return 0;
    }
}

1;
