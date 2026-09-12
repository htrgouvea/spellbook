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
use Carp qw(croak);
use English qw(-no_match_vars);
use FindBin;
use lib "$FindBin::RealBin/../lib";

our $VERSION = '0.0.1';

BEGIN {
    if ( !eval { require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Mojolicious (Mojo::File / Mojo::JSON) is not installed';
    }
}

require Spellbook::Core::Credentials;

# Build a throwaway .config/credentials.json and read it back from there.
my $sandbox = tempdir( CLEANUP => 1 );
mkdir "$sandbox/.config" or croak "Cannot create sandbox config dir: $OS_ERROR";
{
    open my $fh, '>', "$sandbox/.config/credentials.json"
        or croak "Cannot write sandbox credentials: $OS_ERROR";
    print {$fh} '{"github":"s3cr3t-token"}';
    close $fh or croak "Cannot close sandbox credentials: $OS_ERROR";
}

my $origin = getcwd();
chdir $sandbox or croak "Cannot chdir into sandbox: $OS_ERROR";

my $known = Spellbook::Core::Credentials->new( [ '--platform' => 'github' ] );
is( $known, 's3cr3t-token', 'reads the stored secret for a known platform' );

my $unknown = Spellbook::Core::Credentials->new( [ '--platform' => 'gitlab' ] );
is( $unknown, undef, 'an unknown platform yields undef' );

chdir $origin or croak "Cannot restore working directory: $OS_ERROR";

# The help and no-argument branches do not touch the filesystem.
my $help = Spellbook::Core::Credentials->new( ['--help'] );
like( $help, qr/Credentials/sm, 'help output names the module' );

my $empty = Spellbook::Core::Credentials->new( [] );
is( $empty, 0, 'no arguments returns 0' );

done_testing();
