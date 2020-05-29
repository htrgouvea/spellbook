package Modules::Recon::ZoomEye;

use strict;
use warnings;
use JSON;
use LWP::UserAgent;

sub new {
    my ($self, $query) = @_;

    if ($query) {
        my $endpoint  = "https://api.zoomeye.org/host/search?query=$query";
        my $userAgent = LWP::UserAgent -> new();
        my $request   = $userAgent -> get($endpoint,
            "Authorization" => "JWT $zoomToken"
        );

        if ($request -> code() == "200") {
            my $data = $request -> content();
            print $data;
        }
    }   
}

1;