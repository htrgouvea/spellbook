package Spellbook::Recon::HTTP_Probe {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ m{^https?://}ixsm) {
                $target = "https://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $response  = $userAgent -> get($target);
            my $code = $response -> code();

            if ($response -> code()) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::HTTP_Probe
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Define a target to make a HTTP request probe\n\n";
        }

        return 0;
    }
}

1;