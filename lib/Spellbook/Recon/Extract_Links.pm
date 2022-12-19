package Spellbook::Recon::Extract_Links {
    use strict;
    use warnings;
    use Try::Tiny;
    use WWW::Mechanize;
    use List::MoreUtils qw(uniq);

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $deep, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "t|target=s" => \$target,
            "d|deep"     => \$deep
        );

        if ($target) {
            my $mech = WWW::Mechanize -> new (
                autocheck => 0,
                ssl_opts => { verify_hostname => 0 }
            );

            if ($target !~ /^http(s)?:\/\//) {
                $target = "https://$target";
            }

            my $request = $mech -> get($target);
            my @links   = $mech -> links();
            
            for my $link (@links) {
                my $url = $link -> url();

                if (($url) && ($url !~ m/#/)) {
                    push @result, $url;
                    
                    if (($deep) && ($url !~ "^(http|https)://")) {
                        try {
                            push @result, Spellbook::Recon::Extract_Links -> new(["--target" => $target . $url]);
                        }

                        catch {
                            # 
                        }
                    }
                }
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