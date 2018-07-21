#!/usr/bin/perl

sub main {
    my $string = $ARGV[0];
    my $key    = $ARGV[1];
    my $option = $ARGV[2];

    if (@ARGV >= 2) {

        if ($option eq "-d") {
            $key = 26 - $key;
        }

        $caesar = $string =~ s/([A-Z])/chr(((ord(uc $1) - 65 + $key) % 26) + 65)/geir;

        print $caesar, "\n";
    }
}

main();
exit;