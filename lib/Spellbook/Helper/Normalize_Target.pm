package Spellbook::Helper::Normalize_Target {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $scheme, $keep_slash);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'scheme=s'     => \$scheme,
            'k|keep-slash' => \$keep_slash
        );

        if (defined $target && length $target) {
            if (!$scheme) {
                $scheme = 'https';
            }

            if ($target !~ /^https?:\/\//xsm) {
                $target = "$scheme://$target";
            }

            if (!$keep_slash) {
                $target =~ s{/+$}{}xsm;
            }

            return $target;
        }

        if ($help) {
            return "\n"
                . "Helper::Normalize_Target\n"
                . "=====================\n"
                . "-h, --help         See this menu\n"
                . "-t, --target       Target to normalize into a URL\n"
                . "    --scheme       Scheme to prepend when missing (default: https)\n"
                . "-k, --keep-slash   Keep a trailing slash instead of stripping it\n\n";
        }

        return 0;
    }
}

1;
