#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use XML::Simple;

sub main {
    my $file = $ARGV[0];

    if ($file) {
        my $data = XMLin($file);

        my $package = $data -> {package};
        my $backup = $data -> {application} -> {'android:allowBackup'};
        my $debug = $data -> {application} -> {'android:debuggable'};

        print "
            \r[ - ] | Package name: $package
            \r[ - ] | Debug -> $debug
            \r[ - ] | Backup -> $backup\n";
    }
}

main();
exit;