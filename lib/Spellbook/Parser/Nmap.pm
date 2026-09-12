package Spellbook::Parser::Nmap {
    use strict;
    use warnings;
    use Getopt::Long;
    use XML::Simple;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file, @results);

        my $parser = Getopt::Long::Parser -> new (
            config => [qw(no_ignore_case pass_through)]
        );

        $parser -> getoptionsfromarray (
            $parameters,
            'h|help'     => \$help,
            'f|file=s'   => \$file,
        );

        if ($file) {
            my $xml  = XML::Simple -> new();
            my $data = $xml -> XMLin($file);

            my $host = $data -> {host} -> {address} -> {addr};

            return @results;
        }

        if ($help) {
            return "\n"
                . "Parser::Nmap\n"
                . "=====================\n"
                . "-h, --help     See this menu\n"
                . "-f, --file     Set an XML file from Nmap output\n\n";
        }

        return 0;
    }
}

1;
