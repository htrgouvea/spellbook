package Spellbook::Platform::Bugcrowd {
    use strict;
    use warnings;
    use JSON;
    use LWP::UserAgent;
    use Spellbook::Core::Credentials;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        if ($target) {

            my $api_key   = Spellbook::Core::Credentials -> new(["--platform" => "bugcrowd"]);
            my $endpoint  = 'https://api.bugcrowd.com/v1/programs';
            my $useragent = LWP::UserAgent -> new();
            my $request   = HTTP::Request -> new(GET => $url);

            $request -> header('Authorization' => "Bearer $api_key");

            my $response = $useragent -> request($request);
            my $data     = decode_json($response -> content());

            foreach my $program (@{$data -> {programs}}) {
                print $program -> {name} . ": " . $program -> {scope} . "\n";
            }
        }

        if ($help) {
            return 1;
        }

        return 0;
    }
}

1;