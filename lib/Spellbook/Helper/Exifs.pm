package Spellbook::Helper::Exifs;

use strict;
use warnings;
use Image::ExifTool; # https://metacpan.org/pod/Image::ExifTool

sub new {
    my ($self, $image, $payload) = @_; # I need find a method to pass this parameters

    if ($image && $payload) {
        my $exifTool = Image::ExifTool -> new();
        my $source   = $exifTool -> ImageInfo($image);

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
            $exifTool -> SetNewValue($exif, $payload);
            # system ("exiftool -$exif='$payload' $image\n");
        }

        my $write = $exifTool -> WriteInfo($image, "$image.exif");
    }
}

1;