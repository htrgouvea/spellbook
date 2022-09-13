package Spellbook::Helper::Exifs_Write {
    use strict;
    use warnings;
    use Image::ExifTool;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file, $payload, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"      => \$help,
            "f|file=s"    => \$file,
            "p|payload=s" => \$payload
        );

        if ($file && $payload) {
            my $exifTool = Image::ExifTool -> new();
            my $source   = $exifTool -> ImageInfo($file);

            my @tags = (
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

            foreach my $tag (@tags) {
                $exifTool -> SetNewValue($tag, $payload);
            }

            my $write = $exifTool -> WriteInfo($file, "$file.exif");

            return "\n[+] Output file: $file.exif\n\n"
        }

        if ($help) {
            return "
                \rHelper::Exifs_Write
                \r=====================
                \r-h, --help     See this menu
                \r-f, --file     Define a file write the payload
                \r-p --payload   Set a payload to write into file\n\n";
        }

        return 0;
    }
}

1;