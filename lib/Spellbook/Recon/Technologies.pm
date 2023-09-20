package Spellbook::Recon::Technologies {
    use strict;
    use warnings;
    use WWW::Wappalyzer;
    use Spellbook::Core::UserAgent;
    use List::Util 'pairmap';

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
        );

        if ($target) {
            my $userAgent    = Spellbook::Core::UserAgent -> new();
            my $request      = $userAgent -> get($target);
            my %headers_hash = pairmap { $a => [ $request -> headers -> header($a) ] } $request -> headers -> flatten;
            my $wappalyzer   = WWW::Wappalyzer -> new();

            my %detected = $wappalyzer -> detect (
                html    => $request -> decoded_content,
                headers => \%headers_hash
            );

            @result = map { @$_ } values %detected;

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Detect_Tech
                \r=====================
                \r-t, --target     Define the target
                \r-h, --help       See this menu\n\n";
        }

        return 1;
    }
}

1;