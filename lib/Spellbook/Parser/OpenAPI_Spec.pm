package Spellbook::Parser::OpenAPI_Spec {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use Mojo::File;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK => 200;
    Readonly my $TIMEOUT => 30;

    Readonly my @METHODS => qw(get post put delete patch head options);

    sub _extract {
        my ($payload) = @_;

        my $spec = eval { decode_json($payload) };

        if ($spec && (ref $spec eq 'HASH') && ($spec -> {paths})) {
            return $spec;
        }

        if ($payload =~ /"swaggerDoc":\s*([{].*[}])\s*,\s*"customOptions"/msx) {
            return eval { decode_json($1) };
        }

        return;
    }

    sub _is_authenticated {
        my ($operation, $global) = @_;

        my $security = exists $operation -> {security} ? $operation -> {security} : $global;

        if ($security && (ref $security eq 'ARRAY') && @{$security}) {
            return 1;
        }

        foreach my $parameter (@{$operation -> {parameters} || []}) {
            if ((ref $parameter ne 'HASH') || !$parameter -> {required}) {
                next;
            }

            my $in   = lc($parameter -> {in}   // q{});
            my $name = lc($parameter -> {name} // q{});

            if (($in eq 'header') && ($name =~ /secret|authorization|api[-_]?key|token/msx)) {
                return 1;
            }
        }

        return 0;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file, $open_only, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'f|file=s'   => \$file,
            'o|open'     => \$open_only
        );

        if ($target || $file) {
            my $payload;

            if ($file) {
                $payload = Mojo::File -> new($file) -> slurp();
            }

            if ($target) {
                my $user_agent = Spellbook::Core::UserAgent -> new();
                $user_agent -> timeout($TIMEOUT);

                my $request = $user_agent -> get($target);

                if ($request -> code() != $HTTP_OK) {
                    return @result;
                }

                $payload = $request -> content();
            }

            if (!$payload) {
                return @result;
            }

            my $spec = _extract($payload);

            if (!$spec || (ref $spec ne 'HASH')) {
                return @result;
            }

            my $paths  = $spec -> {paths} || {};
            my $global = $spec -> {security};

            foreach my $path (sort keys %{$paths}) {
                my $operations = $paths -> {$path};

                if (ref $operations ne 'HASH') {
                    next;
                }

                foreach my $method (@METHODS) {
                    my $operation = $operations -> {$method};

                    if (!$operation || (ref $operation ne 'HASH')) {
                        next;
                    }

                    my $authenticated = _is_authenticated($operation, $global);

                    if ($open_only && $authenticated) {
                        next;
                    }

                    push @result, sprintf '%-6s %-58s auth=%s', uc $method, $path,
                        $authenticated ? 'yes' : 'NONE';
                }
            }

            return @result;
        }

        if ($help) {
            return "\n"
                . "Parser::OpenAPI_Spec\n"
                . "====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   URL of an OpenAPI/Swagger spec or a swagger-ui-init.js\n"
                . "-f, --file     Read the spec from a local file instead\n"
                . "-o, --open     Only report operations with no authentication\n"
                . "\n"
                . "Lists every operation as: METHOD path auth=yes|NONE\n"
                . "Auth counts declared security schemes and required auth-bearing\n"
                . "headers such as x-webhook-secret, authorization or x-api-key.\n\n";
        }

        return 0;
    }
}

1;
