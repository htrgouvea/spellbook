package Spellbook::Core::Credentials {
    use strict;
    use warnings;
    use Mojo::File;
    use Mojo::JSON qw(decode_json);
    use Getopt::Long;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $platform);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "p|platform=s" => \$platform,
        );
            
        if ($platform) {
            my $credentials = Mojo::File -> new(".config/credentials.json");

            my $read = $credentials -> slurp();
            my $content = decode_json($read);

            return $content -> {$platform}, "\n";
        }

        if ($help) {
            return "
            \rCore::Credentials
            \r==============
            \r-h, --help       See this menu
            \r-p, --platform   Read some credentials filtering by platform\n\n";
        }
        
        return 0;
    }
}

1;