package Spellbook::Parser::Nmap {
    use strict;
    use warnings;
    use XML::Simple;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file, @results);

        Getopt::Long::GetOptionsFromArray (
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
            return "
                \rParser::Nmap
                \r=====================
                \r-h, --help     See this menu
                \r-f, --file     Set an XML file from Nmap output\n\n";
        }

        return 0;
    }
}

1;
