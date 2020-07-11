package Spellbook::Recon::Extract_Links;

use strict;
use warnings;
use WWW::Mechanize;

sub new {
    my ($self, $target) = @_;

    if ($target) {
        my $mech    = WWW::Mechanize -> new();
        my $request = $mech -> get($target);
        my $status  = $mech -> status();

        if ($status == "200") {
            my @links = $mech -> links();
            my @results;

            for my $link (@links) {
                my $url = $link -> url();

                if (($url) && ($url !~ m/#/)) {
                    push @results, $url, "\n";
                }
            }

            return @results;
        }
    }
}

1;