package Spellbook::Android::Strings {
    use strict;
    use warnings;
    use XML::Simple;

    sub new {
        my ($self, $file) = @_;

        if ($file) {
            my $data = XMLin($file);

            # resources.arsc/strings.xml
            # res/xml/file_paths.xml

            
            # if (Dumper($data) =~ m/:\/\//) {
            #     return "true";
            # }
        }

        if ($help) {
            return "
            \rAndroid::
            \r================
            \r-h, --help       See this menu\n";
        }

        return 0;
    }
}

1;