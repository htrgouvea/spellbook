package Spellbook::Auxiliary::Exifs;

use strict;
use warnings;

sub new {
    my ($self, $image, $payload) = @_;

    if ($image && $payload) {
        my @exifs = (
            "ImageDescription",
            "Make",
            "Model",
            "Software",
            "Artist",
            "Copyright",
            "XPTitle",
            "XPComment",
            "XPAuthor",
            "XPSubject",
            "Location",
            "Description",
            "Author"
        );

        foreach my $exif (@exifs) {
            system ("exiftool -$exif='$payload' $image\n");
        }
    }
}

1;