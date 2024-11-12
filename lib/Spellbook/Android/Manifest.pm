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

            my $package = $data -> {"package"};
            my $backup  = $data -> {application} -> {"android:allowBackup"};
            my $debug   = $data -> {application} -> {"android:debuggable"};

            ### clear traffic true
            ### deep link / scheme without host
            ### https://www.mentebinaria.com.br/artigos/pequenas-liga%C3%A7%C3%B5es-grandes-vulnerabilidades-uma-breve-introdu%C3%A7%C3%A3o-a-deep-links-em-android-r75/

            # Exported Android Components
            # Access to protected intents via exported Activities
            # Access to sensitive data via exported Activity

            return join("\n",
                "[ - ] -> Package name: $package",
                "[ - ] -> Debug: $debug",
                "[ - ] -> Backup: $backup",
                "",
                ""
            );
        }

        if ($help) {
            return<<"EOT";

Android::Manifest
==============
-h, --help    See this menu
-f, --file    Pass the AndroidManifest.xml file\n\n";

EOT
        }

        return 0;
    }
}

1;