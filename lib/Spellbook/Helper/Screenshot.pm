package Spellbook::Helper::Screenshot {
    use strict;
    use warnings;
    use Getopt::Long; 
    use Playwright;
    use Try::Tiny;
    use File::Path qw(make_path);
    use File::Spec;
    use File::Basename;

    sub new {
        my ($self, $parameters) = @_;
    
        my ($url, $path, $help, @result);
    
        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "url=s"  => \$url,
            "path=s" => \$path,
            "help"   => \$help
        );

        if ($help) {
            return join("\n",
                "    Helper::Screenshot",
                "    ========================================",
                "    -h, --help      See this menu",
                "    -u, --url       URL to take a screenshot of",
                "    -p, --path      Custom path to save screenshots (default: ./Screenshots/)",
                "",
            );
        }

        return 0 unless $url;

        try {     
            my $screenshot_dir = $path || File::Spec->catdir(dirname($0), 'Screenshots');
            make_path($screenshot_dir) unless -d $screenshot_dir;

            print "[+] Initializing browser...\n";
        
            my $playwright = Playwright->new();
            my $browser = $playwright->launch(
                headless => 1,
                type => 'chrome'
            );
        
            my $page = $browser->newPage();
        
            print "[-] Navigating to $url...\n";
        
            $page->goto($url, {
                waitUntil => 'networkidle',
                timeout   => 30000,
            });
        
            my $filename = $url;
            $filename =~ s/[^\w]/-/gx;  
            $filename =~ s/-+/-/gx;      
            $filename = substr($filename, 0, 50) . '.png';
            my $full_path = File::Spec->catfile($screenshot_dir, $filename);
        
            print "[-] Taking screenshot...\n";
        
            $page->screenshot({
                path      => $full_path,
                full_page => 1,
            });
        
            $browser->close();
            $playwright->quit();
        
            push @result, "[+] Screenshot saved as: $full_path";
        } 
        
        catch {
            push @result, "[!] Error taking screenshot: $_";
        };

        return @result;
    }
}

1;
