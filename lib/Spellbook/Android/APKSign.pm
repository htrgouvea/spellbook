package Spellbook::Android::APKSign;

use strict;
use warnings;

sub new {
    my ($self, $apkfile, $pkgname, $passowrd) = @_;

    if ($apkfile && $pkgname && $password) {
        system("keytool -genkey -keystore $pkgname .jks -storepass $password -storetype jks -alias $pkgname -keyalg rsa -dname \"CN=DESEC\" -keypass $password")
        system("jarsigner -keystore $pkgname .jks -storepass $password -storetype jks -sigalg sha1withrsa -digestalg sha1 $apkfile $pkgname")
        system("jarsigner -verify -certs -verbose $apkfile")
    }

    return 1;
}

1;