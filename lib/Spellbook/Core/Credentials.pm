package Spellbook::Core::Credentials {
    use strict;
    use warnings;
    use Mojo::File;
    use Mojo::JSON qw(decode_json encode_json);
    use Getopt::Long;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $platform, $value);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"       => \$help,
            "p|platform=s" => \$platform,
            "v|value=s"    => \$value,
        );

        if ($platform) {
            my $credentials = Mojo::File -> new(".config/credentials.json");

            my $data = $credentials -> slurp();
            my $content = decode_json($data);

            if ($value) {
                $content -> {$platform} = $value;
                $credentials -> spurt(encode_json($content));
            }

            return $content -> {$platform};
        }

        if ($help) {
            return<<"EOT";

Core::Credentials
==============
-h, --help       See this menu
-p, --platform   Read some credentials filtering by platform
-v, --value      Define a value of a platform\n\n";

EOT
        }

        return 0;
    }
}

1;