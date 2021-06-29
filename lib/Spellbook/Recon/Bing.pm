package Spellbook::Recon::Bing {
    use strict;
    use warnings;
    use WWW::Mechanize;
    use Mojo::Util qw( url_escape);

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $target, @result, %seen, @urls);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help" => \$help,
            "t|target=s" => \$target,
        );

        if ($target) {
            my $mech = WWW::Mechanize -> new();

            my @dorks = (
                "(site:$target) intitle:index.of", # Detecting Directory Listing
                "(site:$target) && (inbody:login || username || user || e-mail || usuário || userid) && (inbody:senha || password || passcode)", # Login pages
                "(site:$target) && (inbody:\"Hacked by\" || \"Owned by\" || \"Pwned by\")", # Possible defaced pages
                "(site:$target) intitle:phpinfo \"published by the PHP Group\"", # PHP errors/warnings
                "site:stackoverflow.com \"$target\"", # Search Stackoverflow.com

                # "(site:$target) intfiletype:\"sql syntax near\" | intfiletype:\"syntax error has occurred\" | intfiletype:\"incorrect syntax near\" | intfiletype:\"unexpected end of SQL command\" | intfiletype:\"Warning: mysql_connect()\" | intfiletype:\"Warning: mysql_query()\" | intfiletype:\"Warning: pg_connect()\"", # SQL errors
                # "(site:$target) filetype:sql | filetype:dbf | filetype:mdb", # Database files exposed
                # "(site:$target) && (filetype:doc || docx || odt || rtf || sxw || psw || ppt || pptx || pps || csv", #Publicly exposed documents
                # "(site:$target) && (filetype:xml || conf || cnf || reg || inf || rdp || fg || txt || ora || ini || env)", # Configuration Files
                # "(site:$target) filetype:log", # Log files exposed
                # "(site:$target) inurl:signup | inurl:register | intitle:Signup", # Signup pages
                # "(site:$target) && (filetype:bkf || bkp || bak || old || backup)", # Backup and old files
                # "(site:$target) inurl:login | inurl:signin | intitle:Login | intitle:sign in | inurl:auth", # Detecting Login pages
                # "site:pastebin.com | site:paste2.org | site:pastehtml.com | site:slexy.org | site:snipplr.com | site:snipt.net | site:tfiletypesnip.com | site:bitpaste.app | site:justpaste.it | site:heypasteit.com | site:hastebin.com | site:dpaste.org | site:dpaste.com | site:codepad.org | site:jsitor.com | site:codepen.io | site:jsfiddle.net | site:dotnetfiddle.net | site:phpfiddle.org | site:ide.geeksforgeeks.org | site:repl.it | site:ideone.com | site:paste.debian.net | site:paste.org | site:paste.org.ru | site:codebeautify.org  | site:codeshare.io | site:trello.com \"$target\"", # Search Pastebin.com / pasting sites
                # "site:github.com | site:gitlab.com \"$target\"", # Search Github.com and Gitlab.com
                # "(site:$target) && (filetype:pdf || ppt || xls || doc) && (inbody:restrito | confidencial | interno | private | restricted | internal)",
            );

            foreach my $dork (@dorks) {
                $dork = url_escape($dork);

                for (my $page = 0; $page <= 10; $page++) {
                    my $url = "http://www.bing.com/search?q=" . $dork . "&first=" . $page . "0";

                    $mech -> get($url);
                    my @links = $mech -> links();
                            
                    foreach my $link (@links) {
                        $url = $link -> url();
                        next if $seen{$url}++;

                        if ($url =~ m/^https?/ && $url !~ m/bing|live|microsoft|msn/) {
                            push @result, "$url\n";
                        }
                    }
                }
            }

            return @result;
        }

        if ($help) {
            return "
                \rRecon::Bing
                \r=====================
                \r-h, --help     See this menu
                \r-t, --target   Define a target\n\n";
        }

        return 0;
    }
}

1;