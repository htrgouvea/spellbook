#!/usr/bin/env perl

# Compile-load check for every module under lib/Spellbook/Core.
#
# When an optional CPAN prerequisite is not installed the corresponding
# module is skipped (instead of failing) so the suite still runs in a
# minimal environment. A real syntax or runtime error in a module is
# always reported as a failure.

use strict;
use warnings;

use Carp;
use English qw(-no_match_vars);
use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

our $VERSION = '0.0.1';

# A few modules read files relative to the repository root, so make sure
# the working directory is predictable regardless of where prove is run.
chdir "$FindBin::RealBin/.." or croak "Unable to chdir to repository root: $OS_ERROR";

my @modules = qw(
    Spellbook::Core::Helper
    Spellbook::Core::Resources
    Spellbook::Core::Module
    Spellbook::Core::Search
    Spellbook::Core::UserAgent
    Spellbook::Core::Credentials
    Spellbook::Core::Orchestrator
);

for my $module (@modules) {
    ( my $file = $module ) =~ s{::}{/}gsxm;
    $file .= '.pm';

    my $loaded = eval { require $file; 1 };
    my $error  = $EVAL_ERROR;

    # A failure caused by a missing optional CPAN prerequisite is skipped,
    # not failed: either the prerequisite is reported directly ("Can't
    # locate Some/Dep.pm") or it surfaces as a cascading reload of a module
    # that already failed to compile earlier in this run.
    #
    # The patterns below run under /x, so every literal space is written as
    # [ ] -- a bare space would be silently discarded by the parser.
    my $missing_dependency =
           ( $error =~ /Can't[ ]locate[ ](\S+[.]pm)/sxm && $1 ne $file )
        || ( $error =~ /Attempt[ ]to[ ]reload[ ]\S+[ ]aborted/sxm );

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
