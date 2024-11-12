package Spellbook::Recon::HTTP_Probe {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//x) {
                $target = "http://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $response  = $userAgent -> get($target);

            if ($response -> code() != 500) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return<<"EOT";

Recon::HTTP_Probe
=====================
-h, --help     See this menu
-t, --target   Define a target to make a HTTP request probe\n\n";

EOT
        }

        return 0;
    }
}

1;