#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use lib "./lib/";
use Getopt::Long;
use Mojo::File;
use Mojo::JSON qw(decode_json);
use Functions::Helper;

sub main {
    my $packages = Mojo::File -> new(".config/packages.json");
    
    if ($packages) {
        my $list = $packages -> slurp();
        my $hash = decode_json($list);
        
        my (
            $show, $module, $target, $read, $output
        );

        GetOptions (
            "--show=s"   => \$show,
            "--module=s" => \$module,
            "--target=s" => \$target,
            "--read=s"   => \$read,
            "--output=s" => \$output
        ) or die (
            return Functions::Helper -> new()
        );

        if ($show) {
            foreach my $package (@{$hash -> {"packages"}}) {
                if ($show eq "all") {
                    print "\nName: ", $package -> {name}, "\n";
                    print "Category: ", $package -> {category}, "\n";
                    print "Description: ", $package -> {description}, "\n";
                    print "Package: ", $package -> {package}, "\n";
                    print "=================================================", "\n\n"
                }

                elsif ($show eq $package -> {category}) {
                    print "\nName: ", $package -> {name}, "\n";
                    print "Category: ", $package -> {category}, "\n";
                    print "Description: ", $package -> {description}, "\n";
                    print "Package: ", $package -> {package}, "\n";
                    print "=================================================", "\n\n"
                }

                else {
                    #
                }
            }

            return 1;
        }

        if ($read) {
            foreach my $package (@{$hash -> {"packages"}}) {
                if ($package -> {package} eq $read) {
                    my $location = $package -> {location};

                    my $file = Mojo::File -> new("./lib/" . $location);
                    
                    print "\n", $file -> slurp(), "\n";
                }
            }

            return 1;
        }

        if ($module) {
            foreach my $package (@{$hash -> {"packages"}}) {
                if ($package -> {package} eq $module) {
                    my $location = $package -> {location};
                    
                    require $location;
                    
                    my @run = "Modules::$module" -> new($target);

                    foreach my $result (@run) {
                        print $result;
                    }
                }
            }

            return 1;
        }

        return Functions::Helper -> new();
    }
}

main();