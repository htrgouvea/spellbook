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
    my $resources = Spellbook::Core::Resources -> new();
    
    if ($resources) {
        my ($search, $module);

        Getopt::Long::GetOptions (
            "s|search=s"    => \$search,
            "m|module=s"    => \$module
        );
        
        return Spellbook::Core::Search -> new($resources, lc $search) if $search;
        return Spellbook::Core::Module -> new($resources, $module, \@ARGV) if $module;
    }

    return Spellbook::Core::Helper -> new();
}

exit main();