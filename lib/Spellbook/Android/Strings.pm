package Spellbook::Android::Strings {
    use strict;
    use warnings;
    use XML::Simple;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $file) = @_;

        if ($file) {
            my $data = XMLin($file);

        }

        if ($help) {
            return "\n"
                . "Android::\n"
                . "================\n"
                . "-h, --help       See this menu\n";
        }

        return 0;
    }
}

1;
