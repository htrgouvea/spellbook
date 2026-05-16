package Spellbook::Recon::Internal_DNS {
    use strict;
    use warnings;
    use Spellbook::Recon::Get_IP;
    use Net::IP;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($target, $help, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target
        );

        if ($target) {
            my $resolv = Spellbook::Recon::Get_IP -> new(['--target' => $target]);
            my $check  = Net::IP -> new($resolv);

            if (($check -> iptype() eq 'PRIVATE') || ($check -> iptype() eq 'LOOPBACK')) {
                push @result, $target;
            }

            return @result;
        }

        if ($help) {
            return join
                "\n",
                "\nRecon::Internal_DNS",
                '=====================',
                '-h, --help     See this menu',
                "-t, --target   Specify the domain to check if it resolves to a private IP\n",
        }

        return 0;
    }
}

1;
