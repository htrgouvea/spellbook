package Spellbook::Recon::Extract_Links {
    use strict;
    use warnings;
    use Try::Tiny;
    use WWW::Mechanize;

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $target, $recursive, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=s" => \$target,
            "r|recursive" => \$recursive
        );

        if ($target) {
            my $mech    = WWW::Mechanize -> new (
                ssl_opts => { verify_hostname => 0 }
            );

            my $request = $mech -> get($target);
            my @links   = $mech -> links();
            
            for my $link (@links) {
                my $url = $link -> url();

                if (($url) && ($url !~ m/#/)) {
                    push @result, $url;

                    if (($url !~ "^(http|https)://") && ($recursive)) {
                        try {
                            my $teste = Spellbook::Recon::Extract_Links -> new(["--target" => $target . $url]);
                        }

                        catch {
                            # 
                        }
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Extrac_Links
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Define a web page to extract all links\n\n";
        }

        return 0;
    }
}

1;