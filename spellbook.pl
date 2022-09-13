#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use Find::Lib "./lib";
use Spellbook::Core::Helper;
use Spellbook::Core::Search;
use Spellbook::Core::Module;
use Spellbook::Core::Resources;
use Getopt::Long qw(:config no_ignore_case pass_through);

sub main {
    my ($search, $module, @result);
    my $resources = Spellbook::Core::Resources -> new();
    
    if ($resources) {
        Getopt::Long::GetOptions (
            "s|search=s"    => \$search,
            "m|module=s"    => \$module
        );

        @result = Spellbook::Core::Search -> new($resources, lc $search) if $search;
        @result = Spellbook::Core::Module -> new($resources, $module, \@ARGV) if $module;

        foreach my $result (@result) {
            print $result, "\n";
        }
    }

    return Spellbook::Core::Helper -> new() unless $search || $module;
}

main();