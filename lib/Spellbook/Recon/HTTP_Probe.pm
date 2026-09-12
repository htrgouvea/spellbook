package Spellbook::Recon::HTTP_Probe {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.2';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            if ($target !~ m{^https?://}ixsm) {
                $target = "https://$target";
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            my $response   = $user_agent -> get($target);

            my $warning = $response -> header('Client-Warning') || q{};

            if ($warning ne 'Internal response') {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::HTTP_Probe\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Define a target to make a HTTP request probe\n\n";
        }

        return 0;
    }
}

1;