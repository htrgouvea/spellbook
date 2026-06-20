#!/usr/bin/env perl

# Compile-load check for the core modules and the pure-logic helpers.
#
# When an optional CPAN prerequisite is not installed the corresponding
# module is skipped (instead of failing) so the suite still runs in a
# minimal environment. A real syntax or runtime error in a module is
# always reported as a failure.

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

# A few modules read files relative to the repository root, so make sure
# the working directory is predictable regardless of where prove is run.
chdir "$FindBin::RealBin/.." or die "Unable to chdir to repository root: $!";

my @modules = qw(
    Spellbook::Core::Helper
    Spellbook::Core::Module
    Spellbook::Core::Search
    Spellbook::Core::Resources
    Spellbook::Core::UserAgent
    Spellbook::Helper::Uniq
    Spellbook::Helper::Permutations
    Spellbook::Helper::Generate_UUID
    Spellbook::Helper::Host_Normalization
);

for my $module (@modules) {
    ( my $file = $module ) =~ s{::}{/}g;
    $file .= '.pm';

    my $loaded = eval { require $file; 1 };
    my $error  = $@;

    # A failure caused by a missing optional CPAN prerequisite is skipped,
    # not failed: either the prerequisite is reported directly ("Can't
    # locate Some/Dep.pm") or it surfaces as a cascading reload of a module
    # that already failed to compile earlier in this run.
    my $missing_dependency =
           ( $error =~ /Can't locate (\S+\.pm)/ && $1 ne $file )
        || ( $error =~ /Attempt to reload \S+ aborted/ );

    if ( !$loaded && $missing_dependency ) {
        SKIP: {
            skip "$module needs an optional dependency", 1;
        }
        next;
    }

    ok( $loaded, "$module loads cleanly" )
        or diag($error);
}

done_testing();
