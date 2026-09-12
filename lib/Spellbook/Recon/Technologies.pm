package Spellbook::Recon::Technologies {
    use strict;
    use warnings;
    use Getopt::Long;
    use WWW::Wappalyzer;
    use Spellbook::Core::UserAgent;
    use List::Util 'pairmap';

    our $VERSION = '0.0.2';

    my $WAPPALYZER;

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//msx) {
                $target = "https://$target";
            }

            my $user_agent    = Spellbook::Core::UserAgent -> new();
            my $request      = $user_agent -> get($target);
            my %headers_hash = pairmap { $a => [ $request -> headers -> header($a) ] } $request -> headers -> flatten;

            # WWW::Wappalyzer->new() loads and parses the whole fingerprint
            # database. Build it once and reuse it across targets instead of
            # reloading the database on every call under the Orchestrator.
            if (!$WAPPALYZER) {
                $WAPPALYZER = WWW::Wappalyzer -> new();
            }

            my %detected = $WAPPALYZER -> detect (
                html    => $request -> decoded_content,
                headers => \%headers_hash
            );

            @result = map { @{$_} } values %detected;

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Detect_Tech\n"
                . "=====================\n"
                . "-t, --target     Define the target\n"
                . "-h, --help       See this menu\n\n";
        }

        return 1;
    }
}

1;
