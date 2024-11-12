package Spellbook::Parser::Nozaki {
    use strict;
    use warnings;
    use JSON;
    use Mojo::File;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $file, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"   => \$help,
            "f|file=s" => \$file,
        );

        if ($file) {
            my $load_file = Mojo::File -> new($file);
            my $data     = $load_file -> slurp();
            my $content  = decode_json($data);

            print $content;

            return @result;
        }

        if ($help) {
            return<<"EOT";

Parser::Nozaki
=====================
-h, --help     See this menu
-t, --target   \n\n";

EOT
        }

        return 0;
    }
}

1;