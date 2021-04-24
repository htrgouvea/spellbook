package Spellbook::Recon::Extract_Links {
    use strict;
    use warnings;
    use WWW::Mechanize;

    sub new {
        my ($self, $target) = @_;
        my @results = ();

        if ($target) {
            my $mech    = WWW::Mechanize -> new();
            my $request = $mech -> get($target);
            my @links   = $mech -> links();
            
            for my $link (@links) {
                my $url = $link -> url();

                if (($url) && ($url !~ m/#/)) {
                    push @results, $url, "\n";
                }
            }
        }

        return @results;
    }
}

1;