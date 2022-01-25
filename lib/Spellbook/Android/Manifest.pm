package Spellbook::Android::Manifest {
    use strict;
    use warnings;
    use XML::Simple;

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $file);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"    => \$help,
            "f|file=s"  => \$apkfile
        );

        if ($file) {
            my $data = XMLin($file);

            my $package = $data -> {'package'};
            my $backup  = $data -> {application} -> {'android:allowBackup'};
            my $debug   = $data -> {application} -> {'android:debuggable'};

            ### clear traffic true
            ### deep link / scheme without host
            ### 

            return "
                \r[ - ] -> Package name: $package
                \r[ - ] -> Debug: $debug
                \r[ - ] -> Backup: $backup\n\n";
        }

        if ($help) {
            return "
            \rAndroid::Manifest
            \r==============
            \r-h, --help    See this menu
            \r-f, --file    Pass the AndroidManifest.xml file\n\n";
        }
        
        return 0;
    }
}

1;