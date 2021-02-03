#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use lib "./lib/";
use Getopt::Long;
use Mojo::File;
use Mojo::JSON qw(decode_json);
use Spellbook::Core::Helper;

sub main {
    my $modules = Mojo::File -> new(".config/modules.json");
    
    if ($modules) {
        my $list = $modules -> slurp();
        my $hash = decode_json($list);
        
        my ($show, $module, $target, $read);

        GetOptions (
            "--show=s"   => \$show,
            "--module=s" => \$module,
            "--target=s" => \$target,
            "--read=s"   => \$read
        ) or die (
            return Spellbook::Core::Helper -> new()
        );

        # Yeah, I know, i need refact this shit
        if ($show) {
            foreach my $module (@{$hash -> {"modules"}}) {
                if ($show eq "all") {
                    print "Module: ", $module -> {module}, "\n";
                    print "Category: ", $module -> {category}, "\n";
                    print "Description: ", $module -> {description}, "\n";
                    print "=================================================", "\n\n"
                }

                elsif ($show eq $module -> {category}) {
                    print "Module: ", $module -> {module}, "\n";
                    print "Category: ", $module -> {category}, "\n";
                    print "Description: ", $module -> {description}, "\n";
                    print "=================================================", "\n\n"
                }

                else {
                    #
                }
            }

            return 1;
        }

        if ($read) {
            foreach my $module (@{$hash -> {"modules"}}) {
                if ($module -> {module} eq $read) {
                    my $location = $module -> {location};

                    my $file = Mojo::File -> new("./lib/" . $location);
                    
                    print "\n", $file -> slurp(), "\n";
                }
            }

            return 1;
        }

        if ($module) {
            foreach my $package (@{$hash -> {"modules"}}) {
                if ($package -> {module} eq $module) {
                    
                    my $location = $package -> {location};
                    
                    require "Spellbook/" . $location;
                    
                    my @run = "Spellbook::$module" -> new($target);
                    
                    foreach my $result (@run) {
                        print $result;
                    }
                }
            }

            return 1;
        }

        return Spellbook::Core::Helper -> new();
    }
}

main();