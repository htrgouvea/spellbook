package Spellbook::Recon::Content_Discovery {
    use strict;
    use warnings;
    use Getopt::Long;
    use Mojo::File;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $TIMEOUT   => 12;
    Readonly my $NOT_FOUND => 404;

    Readonly my @DEFAULT_PATHS => qw(
        .env
        .env.local
        .git/config
        .git/HEAD
        .DS_Store
        .aws/credentials
        config.json
        appsettings.json
        docker-compose.yml
        swagger.json
        swagger-ui.html
        openapi.json
        api-docs
        v2/api-docs
        v3/api-docs
        docs
        actuator
        actuator/env
        actuator/health
        metrics
        debug
        phpinfo.php
        server-status
        backup.zip
        robots.txt
        admin
        health
    );

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $wordlist, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'       => \$help,
            't|target=s'   => \$target,
            'w|wordlist=s' => \$wordlist
        );

        if ($target) {
            if ($target !~ m{^https?://}ixsm) {
                $target = "https://$target";
            }

            $target =~ s{/\z}{}msx;

            my @paths = @DEFAULT_PATHS;

            if ($wordlist) {
                my $handle = Mojo::File -> new($wordlist) -> open('<');
                @paths = ();

                while (defined(my $line = $handle -> getline())) {
                    chomp $line;
                    $line =~ s{\A/}{}msx;

                    if (length $line) {
                        push @paths, $line;
                    }
                }
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();
            $user_agent -> timeout($TIMEOUT);
            $user_agent -> max_redirect(0);

            foreach my $path (@paths) {
                my $url      = "$target/$path";
                my $response = $user_agent -> get($url);
                my $warning  = $response -> header('Client-Warning') || q{};

                if ($warning eq 'Internal response') {
                    next;
                }

                my $status = $response -> code();

                if ($status == $NOT_FOUND) {
                    next;
                }

                my $length = $response -> header('Content-Length');

                if (!defined $length) {
                    $length = length($response -> content // q{});
                }

                my $location = $response -> header('Location') || q{};

                push @result, join q{ | }, "/$path", $status, "len=$length", $location;
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Content_Discovery\n"
                . "========================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     Target to probe\n"
                . "-w, --wordlist   File of paths to try instead of the built-in list\n"
                . "\n"
                . "Probes each path and reports only what is not a 404, one line per hit:\n"
                . "path | status | length | redirect-location\n\n";
        }

        return 0;
    }
}

1;
