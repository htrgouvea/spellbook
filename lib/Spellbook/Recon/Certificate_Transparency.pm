package Spellbook::Recon::Certificate_Transparency {
    use strict;
    use warnings;
    use Getopt::Long;
    use JSON;
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK  => 200;
    Readonly my $TIMEOUT  => 60;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $wildcards, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'      => \$help,
            't|target=s'  => \$target,
            'w|wildcards' => \$wildcards
        );

        if ($target) {
            if ($target =~ /^http(s)?:\/\//msx) {
                $target =~ s/^http(s)?:\/\///msx;
            }

            my $user_agent = Spellbook::Core::UserAgent -> new();

            $user_agent -> timeout($TIMEOUT);

            my $endpoint = "https://crt.sh/?q=%25.$target&output=json";
            my $request  = $user_agent -> get($endpoint);

            if ($request -> code() != $HTTP_OK) {
                return @result;
            }

            my $content = eval { decode_json($request -> content) };

            if (!$content || (ref $content ne 'ARRAY')) {
                return @result;
            }

            foreach my $entry (@{$content}) {
                my $names = $entry -> {name_value};

                if (!$names) {
                    next;
                }

                foreach my $name (split /\n/msx, $names) {
                    $name = lc $name;
                    $name =~ s/\A\s+|\s+\z//gmsx;

                    if ($name =~ /\A[*][.]/msx) {
                        if (!$wildcards) {
                            next;
                        }

                        $name =~ s/\A[*][.]//msx;
                    }

                    if ($name !~ /\A[[:lower:][:digit:]._-]+\z/msx) {
                        next;
                    }

                    if ($name !~ /[.]\Q$target\E\z|\A\Q$target\E\z/msx) {
                        next;
                    }

                    push @result, $name;
                }
            }

            my %seen;
            my @unique = sort grep { !$seen{$_}++ } @result;

            return @unique;
        }

        if ($help) {
            return "\n"
                . "Recon::Certificate_Transparency\n"
                . "==============================\n"
                . "-h, --help       See this menu\n"
                . "-t, --target     Define a domain to search in the CT logs\n"
                . "-w, --wildcards  Also emit wildcard entries, stripped of the '*.'\n\n";
        }

        return 0;
    }
}

1;
