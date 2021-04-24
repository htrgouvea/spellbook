package Spellbook::Recon::Find_Emails;

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use Spellbook::Core::Credentials;

sub new {
    my ($self, $target) = @_;
    my @result = ();

    if ($target) {
        my $apiKey    = Spellbook::Core::Credentials -> new("hunter");
        my $endpoint  = "https://api.hunter.io/v2/domain-search?domain=$target&api_key=$apiKey";
        my $userAgent = LWP::UserAgent -> new();
	    my $request   = $userAgent -> get($endpoint);
	    my $httpCode  = $request -> code();

        if ($httpCode == 200) {
            my $content = decode_json($request -> content);

            foreach my $email (@{$content -> {data} -> {emails}}) {
                push @result, $email -> {'value'}, "\n";
            }
        }    

        return @result;
    }
}

1;