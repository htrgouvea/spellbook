package Modules::Parser::Amass;

use strict;
use warnings;
use JSON;

sub new {
    my ($self, $file) = @_;

    if ($file) {
        my @results = ();
        open (my $domains, "<", $file);

        while (<$domains>) {
            chomp($_);

            my $data = decode_json($_);
            push @results, $data -> {name}, "\n";
        }

        close ($domains);
        return @results;
    }
}

1;