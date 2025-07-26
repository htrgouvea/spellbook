package Spellbook::Android::APKSign {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $apkfile, $name, $password);

        Getopt::Long::GetOptionsFromArray (
            $parameters,
            "h|help"       => \$help,
            "a|apk=s"      => \$apkfile,
            "n|name=s"     => \$name,
            "p|password=s" => \$password,
        );

        if ($apkfile && $name && $password) {
            system("keytool -genkey -keystore $name .jks -storepass $password -storetype jks -alias $name -keyalg rsa -dname \"CN=Google\" -keypass $password");
            system("jarsigner -keystore $name .jks -storepass $password -storetype jks -sigalg sha1withrsa -digestalg sha1 $apkfile $name");
            system("jarsigner -verify -certs -verbose $apkfile");
        }

        if ($help) {
            return "
            \rAndroid::APKSign
            \r================
            \r-h, --help       See this menu
            \r-a, --apk        Pass the APK file
            \r-n, --name       Set de package name
            \r-p, --password   Define a password\n";
        }
        
        return 0;
    }
}

1;