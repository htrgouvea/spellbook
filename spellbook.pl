#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use Mojo::File;
use Find::Lib "./lib";
use Spellbook::Core::Helper;
use Spellbook::Core::Search;
use Spellbook::Core::Module;
use Mojo::JSON qw(decode_json);
use Getopt::Long qw(:config no_ignore_case);;

sub main {
    my $resources = Mojo::File -> new(".config/modules.json");
    
    if ($resources) {
        my $list = $resources -> slurp();
        my $modules = decode_json($list);
        
        my ($search, $module, $target, $parameter);

        GetOptions (
            "s|search=s"  => \$search,
            "m|module=s"  => \$module,
            "t|target=s"  => \$target,
            "p|parameter=s" => \$parameter
        );
        
        return Spellbook::Core::Search -> new($modules, $search) if $search;
        return Spellbook::Core::Module -> new($modules, $module, $target, $parameter) if $module;
        return Spellbook::Core::Helper -> new();
    }
}

main();