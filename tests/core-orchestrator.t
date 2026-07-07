#!/usr/bin/env perl

# Spellbook::Core::Orchestrator fans work out across threads. The threaded
# dispatch path needs live targets, so here we cover the deterministic
# branches: the help text and the no-argument return value.

use strict;
use warnings;

use Test::More;
use Getopt::Long ();
use FindBin;
use lib "$FindBin::RealBin/../lib";

BEGIN {
    unless (
        eval {
            require threads;
            require Thread::Queue;
            require Readonly;
            require Mojo::File;
            1;
        }
        )
    {
        plan skip_all => 'threads / Thread::Queue / Readonly / Mojolicious are not installed';
    }
}

require Spellbook::Core::Orchestrator;

my $help = Spellbook::Core::Orchestrator->new( ['--help'] );
like( $help, qr/Orchestrator/, 'help output names the module' );

my $empty = Spellbook::Core::Orchestrator->new( [] );
is( $empty, 0, 'no arguments returns 0' );

done_testing();
