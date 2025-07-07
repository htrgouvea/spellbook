package Spellbook::Recon::Public_DNS {
    use strict;
    use warnings;
    use Spellbook::Recon::Internal_DNS;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);

        Getopt::Long::GetOptionsFromArray(
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
                "\r\nRecon::Public_DNS",
                "\r=====================",
                "\r-h, --help     See this menu",
                "\r-t, --target   Verify if a domain has a resolution to public IP\n";
        }

        return 0;
    }
}

1;