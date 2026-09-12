package Spellbook::Recon::Public_DNS {
    use strict;
    use warnings;
    use Getopt::Long;
    use Spellbook::Recon::Internal_DNS;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            my $verify = Spellbook::Recon::Internal_DNS -> new([ '--target', $target ]);

            if (!$verify) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return join
                "\n",
                "\nRecon::Public_DNS",
                '=====================',
                '-h, --help     See this menu',
                "-t, --target   Verify if a domain has a resolution to public IP\n";
        }

        return 0;
    }
}

1;
