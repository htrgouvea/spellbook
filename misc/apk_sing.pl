#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

sub main {
    my $apkfile  = $ARGV[0];
    my $pkgname  = $ARGV[1];
    my $password = $ARGV[2];

    if ($apkfile && $pkgname && $password) {
        system("keytool -genkey -keystore $pkgname .jks -storepass $password -storetype jks -alias $pkgname -keyalg rsa -dname \"CN=DESEC\" -keypass $password")
        system("jarsigner -keystore $pkgname .jks -storepass $password -storetype jks -sigalg sha1withrsa -digestalg sha1 $apkfile $pkgname")
        system("jarsigner -verify -certs -verbose $apkfile")
        
        exit;
    }

    print "[!] - Usage: perl apk_sign.pl <apkfile.apk> <package_name> <password>\n";
}

main();
exit;