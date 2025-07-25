package Spellbook::Recon::Extract_Links {
    use strict;
    use warnings;
    use Try::Tiny;
    use WWW::Mechanize;
    use List::MoreUtils qw(uniq);

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $deep, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'd|deep'     => \$deep
        );

        if ($target) {
            my $mech = WWW::Mechanize -> new (
                autocheck => 0,
                ssl_opts => { verify_hostname => 0 }
            );

            if ($target !~ /^http(s)?:\/\//x) {
                $target = "https://$target";
            }

            if ($target =~ /\/$/x) { chop($target); }

            my $request = $mech -> get($target);
            my @links   = $mech -> links();

            for my $link (@links) {
                my $url = $link -> url();

                if (($url) && ($url !~ m/#/x) && ($url !~ /^http(s)?:\/\//x)) {
                    if ($url !~ /^\//x) {
                        $url = "/" . $url;
                    }

                    push @result, $url;

                    # if ($deep) {
                    #     try {
                    #         push @result, Spellbook::Recon::Extract_Links -> new(["--target" => $target . $url]);
                    #     }
                    # }
                }
            }

            for my $item (@result) {
                $item = $target . $item;
            }

            return uniq @result;
        }

        if ($help) {
            return "
                \rRecon::Extrac_Links
                \r=====================
                \r-h, --help       See this menu
                \r-t, --target     Define a web page to extract all links
                \r-d, --deep       Draft recursive function\n\n";
        }

        return 0;
    }
}

1;