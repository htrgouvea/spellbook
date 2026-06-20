#!/usr/bin/env perl

# Spellbook::Core::Credentials reads a platform secret from
# .config/credentials.json (relative to the working directory) and exposes
# help / no-argument behaviour.

use strict;
use warnings;

use Test::More;
use Getopt::Long ();
use File::Temp qw(tempdir);
use Cwd qw(getcwd);
use FindBin;
use lib "$FindBin::RealBin/../lib";

BEGIN {
    unless ( eval { require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Mojolicious (Mojo::File / Mojo::JSON) is not installed';
    }
}

require Spellbook::Core::Credentials;

# Build a throwaway .config/credentials.json and read it back from there.
my $sandbox = tempdir( CLEANUP => 1 );
mkdir "$sandbox/.config" or die "Cannot create sandbox config dir: $!";
{
    open my $fh, '>', "$sandbox/.config/credentials.json"
        or die "Cannot write sandbox credentials: $!";
    print {$fh} '{"github":"s3cr3t-token"}';
    close $fh;
}

my $origin = getcwd();
chdir $sandbox or die "Cannot chdir into sandbox: $!";

my $known = Spellbook::Core::Credentials->new( [ '--platform' => 'github' ] );
is( $known, 's3cr3t-token', 'reads the stored secret for a known platform' );

my $unknown = Spellbook::Core::Credentials->new( [ '--platform' => 'gitlab' ] );
is( $unknown, undef, 'an unknown platform yields undef' );

chdir $origin or die "Cannot restore working directory: $!";

# The help and no-argument branches do not touch the filesystem.
my $help = Spellbook::Core::Credentials->new( ['--help'] );
like( $help, qr/Credentials/, 'help output names the module' );

my $empty = Spellbook::Core::Credentials->new( [] );
is( $empty, 0, 'no arguments returns 0' );

done_testing();
