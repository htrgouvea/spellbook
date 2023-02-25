package Spellbook::Parser::Nmap {
    use strict;
    use warnings;
    use XML::Simple;
    
    # https://metacpan.org/pod/Nmap::Parser

    sub new {
        my ($self, $parameters)= @_;
        my ($help, $file);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"     => \$help,
            "f|file=s"   => \$file,
        );

        if ($file) {
            my $xml  = XML::Simple -> new();
            my $data = $xml -> XMLin($file);
            
            my $host = $data -> {host} -> {address} -> {addr};
            
            # foreach my $content (@{$data -> {host} -> {ports} -> {port}}) {
            #         print Dumper($content);
            #         push @result, $element -> {Key};
            # }
           
            #     my $state = $content -> {state} -> {state};

            #     if (($state eq "open") || ($state eq "filtered")) {
            #         my $port     = $content -> {portid};
            #         my $protocol = $content -> {protocol};
            #         my $service  = $content -> {service} -> {name};

            #         push @results, "$host -> [$protocol] | [$state]-> $port \t | $service\n";
            #     }
            # };
            
            # my @results;
            # return @results;
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