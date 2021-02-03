package Spellbook::Recon::Bing;

use strict;
use warnings;
use WWW::Mechanize;
use Mojo::Util qw( url_escape);

sub new {
    my ($self, $domain) = @_;

    if ($domain) {
        my $mech = WWW::Mechanize -> new();
        my %seen = ();
        my @urls = ();

        my @dorks = (
            "(site:$domain) && (filetype:doc || docx || odt || rtf || sxw || psw || ppt || pptx || pps || csv", #Publicly exposed documents
            "(site:$domain) intitle:index.of", # Detecting Directory Listing
            "(site:$domain) && (filetype:xml || conf || cnf || reg || inf || rdp || fg || txt || ora || ini || env)", # Configuration Files
            # "(site:$domain) filetype:sql | filetype:dbf | filetype:mdb", # Database files exposed
            # "(site:$domain) filetype:log", # Log files exposed
            "(site:$domain) && (filetype:bkf || bkp || bak || old || backup)", # Backup and old files
            # "(site:$domain) inurl:login | inurl:signin | intitle:Login | intitle:sign in | inurl:auth", # Detecting Login pages
            # "(site:$domain) intfiletype:\"sql syntax near\" | intfiletype:\"syntax error has occurred\" | intfiletype:\"incorrect syntax near\" | intfiletype:\"unexpected end of SQL command\" | intfiletype:\"Warning: mysql_connect()\" | intfiletype:\"Warning: mysql_query()\" | intfiletype:\"Warning: pg_connect()\"", # SQL errors
            # "(site:$domain) filetype:php intitle:phpinfo \"published by the PHP Group\"", # PHP errors / warnings
            # "(site:$domain) inurl:signup | inurl:register | intitle:Signup", # Signup pages
            "(site:$domain) && (inbody:\"Hacked by\" || \"Owned by\" || \"Pwned by\")", # Possible deface pages
            # "site:pastebin.com | site:paste2.org | site:pastehtml.com | site:slexy.org | site:snipplr.com | site:snipt.net | site:tfiletypesnip.com | site:bitpaste.app | site:justpaste.it | site:heypasteit.com | site:hastebin.com | site:dpaste.org | site:dpaste.com | site:codepad.org | site:jsitor.com | site:codepen.io | site:jsfiddle.net | site:dotnetfiddle.net | site:phpfiddle.org | site:ide.geeksforgeeks.org | site:repl.it | site:ideone.com | site:paste.debian.net | site:paste.org | site:paste.org.ru | site:codebeautify.org  | site:codeshare.io | site:trello.com \"$domain\"", # Search Pastebin.com / pasting sites
            # "site:stackoverflow.com \"$domain\"", # Search Stackoverflow.com
            # "site:github.com | site:gitlab.com \"$domain\"", # Search Github.com and Gitlab.com
            "(site:$domain) && (filetype:pdf || ppt || xls || doc) && (inbody:restrito | confidencial | interno | private | restricted | internal)",
            "(site:$domain) && (inbody:login || username || user || e-mail || usuário || userid) && (inbody:senha || password || passcode)",
        );

        my @results = ();

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
                        push @results, "$url\n";
                    }
                }
            }
        }

        return @results;
    }
}

1;