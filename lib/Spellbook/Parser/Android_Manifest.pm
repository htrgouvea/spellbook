package Spellbook::Parser::Android_Manifest;

use strict;
use warnings;
use XML::Simple;

sub new {
    my ($self, $file) = @_;

    if ($file) {
        my $data = XMLin($file);

        my $package = $data -> {'package'};
        my $backup  = $data -> {application} -> {'android:allowBackup'};
        my $debug   = $data -> {application} -> {'android:debuggable'};
        
        return "
            \r[ - ] -> Package name: $package
            \r[ - ] -> Debug: $debug
            \r[ - ] -> Backup: $backup\n\n";
    }
}

1;