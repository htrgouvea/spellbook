#!/usr/bin/env perl

use 5.030;
use strict;
use warnings;
use Find::Lib "./lib";
use Spellbook::Core::Helper;
use Spellbook::Core::Search;
use Spellbook::Core::Module;
use Getopt::Long qw(:config no_ignore_case pass_through);

sub main {
    my ($search, $module, @result);
    
    Getopt::Long::GetOptions (
        "s|search=s" => \$search,
        "m|module=s" => \$module
    );

    @result = Spellbook::Core::Search -> new($search) if $search;
    @result = Spellbook::Core::Module -> new($module, \@ARGV) if $module;

    foreach my $item (@result) {
        print $item, "\n";
    }

    return Spellbook::Core::Helper -> new() unless $search || $module;
}

main();