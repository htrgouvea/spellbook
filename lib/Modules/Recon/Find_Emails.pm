package Modules::Recon::Find_Emails;

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use Core::GetCredentials;

sub new {
    my ($self, $domain) = @_;

    if ($domain) {
        my $apiKey    = Core::GetCredentials -> new("hunter");
        my $endpoint  = "https://api.hunter.io/v2/domain-search?domain=$domain&api_key=$apiKey";
        my $userAgent = LWP::UserAgent -> new();
	    my $request   = $userAgent -> get($endpoint);
	    my $httpCode  = $request -> code();

        my @result = ();

        if ($httpCode == 200) {
            my $content = decode_json($request -> content);

            foreach my $email (@{$content -> {'data'} -> {'emails'}}) {
                push @result, $email -> {'value'}, "\n";
            }
        }

        return @result;
    }
}

1;