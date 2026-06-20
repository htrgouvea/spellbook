package Spellbook::Recon::HTTP_Screenshot {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $DEFAULT_RESOLUTION => '1280,720';

    sub _find_browser {
        my ($custom) = @_;

        my @candidates = (
            'google-chrome-stable',
            'google-chrome',
            'chromium-browser',
            'chromium',
            'chrome-headless-shell',
            'chrome'
        );

        if ($custom) {
            if (-x $custom && ! -d $custom) {
                return $custom;
            }

            return;
        }

        if ($ENV{'CHROME_BIN'} && -x $ENV{'CHROME_BIN'}) {
            return $ENV{'CHROME_BIN'};
        }

        my $path = $ENV{'PATH'} // q{};

        foreach my $directory (split /:/msx, $path) {
            foreach my $name (@candidates) {
                my $binary = "$directory/$name";

                if (-x $binary && ! -d $binary) {
                    return $binary;
                }
            }
        }

        return;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $output, $binary, @result);

        my $resolution = $DEFAULT_RESOLUTION;

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'         => \$help,
            't|target=s'     => \$target,
            'o|output=s'     => \$output,
            'b|binary=s'     => \$binary,
            'r|resolution=s' => \$resolution
        );

        if ($target) {
            if ($target !~ /^http(?:s)?:\/\//msx) {
                $target = "https://$target";
            }

            if (!$output) {
                my $name = $target;

                $name =~ s/^http(?:s)?:\/\///msx;
                $name =~ s/[^\w.-]+/_/gmsx;
                $name =~ s/_+\z//msx;

                $output = "$name.png";
            }

            my $browser = _find_browser($binary);

            if (!$browser) {
                return "\n[!] Could not find a Chrome/Chromium binary, "
                    . "install Chromium or set the CHROME_BIN environment variable.\n";
            }

            my @command = (
                $browser,
                '--headless',
                '--no-sandbox',
                '--disable-gpu',
                '--disable-dev-shm-usage',
                '--hide-scrollbars',
                '--disable-logging',
                '--log-level=3',
                '--virtual-time-budget=5000',
                "--window-size=$resolution",
                "--screenshot=$output",
                $target
            );

            my $status = system @command;

            if ($status == 0 && -s $output) {
                push @result, $output;
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::HTTP_Screenshot\n"
                . "=====================\n"
                . "-h, --help         See this menu\n"
                . "-t, --target       Set a target URL to screenshot\n"
                . "-o, --output       Set the output file path (default: <host>.png)\n"
                . "-b, --binary       Set the path to the Chrome/Chromium binary\n"
                . "-r, --resolution   Set the viewport size (default: $DEFAULT_RESOLUTION)\n\n";
        }

        return 0;
    }
}

1;
