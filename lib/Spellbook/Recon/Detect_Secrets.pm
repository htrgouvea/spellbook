package Spellbook::Recon::Detect_Secrets {
    use strict;
    use warnings;
    use Getopt::Long;
    use Mojo::File;
    use List::MoreUtils qw(uniq);
    use Spellbook::Core::UserAgent;

    our $VERSION = '0.0.1';

    use Readonly;
    Readonly my $HTTP_OK      => 200;
    Readonly my $TIMEOUT      => 30;
    Readonly my $MIN_ENTROPY  => 16;

    Readonly my $WORD => qr{[[:alnum:]_-]}msx;

    Readonly my @SIGNATURES => (
        [ 'aws-access-key'  => qr{AKIA[[:upper:][:digit:]]{16}}msx ],
        [ 'google-api-key'  => qr{AIza$WORD{35}}msx ],
        [ 'slack-token'     => qr{xox[baprs]-[[:alnum:]-]{10,}}msx ],
        [ 'github-token'    => qr{gh[pousr]_[[:alnum:]]{36}}msx ],
        [ 'stripe-live-key' => qr{[sp]k_live_[[:alnum:]]{16,}}msx ],
        [ 'private-key'     => qr{-----BEGIN[[:space:][:upper:]]*PRIVATE[[:space:]]KEY-----}msx ],
        [ 'jwt'             => qr{eyJ$WORD{10,}[.]eyJ$WORD{10,}[.]$WORD{10,}}msx ],
        [ 'twilio-sid'      => qr{AC[[:xdigit:]]{32}}msx ],
        [ 'sendgrid-key'    => qr{SG[.]$WORD{22}[.]$WORD{43}}msx ],
    );

    Readonly my $SECRET_WORD => qr{api[_-]?key|apikey|secret|token|password|passwd|credential}imsx;

    Readonly my $SECRET_NAME => qr{$WORD*(?:$SECRET_WORD)$WORD*}imsx;

    Readonly my $SECRET_VALUE => qr{[[:alnum:]_./+-]{$MIN_ENTROPY,}}msx;

    Readonly my $ASSIGNMENT => qr{($SECRET_NAME)["']?\s*[:=]\s*["']($SECRET_VALUE)["']}imsx;

    Readonly my %PLACEHOLDER => map { $_ => 1 } qw(true false null undefined);

    Readonly my @IGNORED => (
        qr{\A[[:lower:]_]+_[[:lower:]_]+\z}msx,
        qr{\A[\$]\x7b}msx,
        qr{\Aprocess[.]env}msx,
    );

    sub _looks_placeholder {
        my ($value) = @_;

        if (exists $PLACEHOLDER{lc $value}) {
            return 1;
        }

        foreach my $pattern (@IGNORED) {
            if ($value =~ $pattern) {
                return 1;
            }
        }

        if ($value !~ /[[:digit:]]/msx) {
            return 1;
        }

        return 0;
    }

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $file, @result);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'f|file=s'   => \$file
        );

        if ($target || $file) {
            my $payload;
            my $origin = $file // $target;

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

            foreach my $signature (@SIGNATURES) {
                my ($label, $pattern) = @{$signature};

                while ($payload =~ /($pattern)/gmsx) {
                    push @result, join q{ | }, $origin, $label, $1;
                }
            }

            while ($payload =~ /$ASSIGNMENT/gmsx) {
                my ($name, $value) = ($1, $2);

                if (_looks_placeholder($value)) {
                    next;
                }

                push @result, join q{ | }, $origin, "assignment:$name", $value;
            }

            return uniq @result;
        }

        if ($help) {
            return "\n"
                . "Recon::Detect_Secrets\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   URL of a script or text resource to scan\n"
                . "-f, --file     Scan a local file instead\n"
                . "\n"
                . "Reports one line per hit: source | kind | value\n"
                . "Matches known vendor key formats plus generic key/secret/token\n"
                . "assignments, skipping placeholders and env-var indirection.\n\n";
        }

        return 0;
    }
}

1;
