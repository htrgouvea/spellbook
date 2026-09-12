#!/usr/bin/env perl

# Spellbook is usable as a library, not only through spellbook.pl: a module
# can be loaded on its own, from any working directory, without the caller
# having to pre-load the dispatcher's dependencies first.

use strict;
use warnings;

use Carp;
use English qw(-no_match_vars);
use Test::More;
use File::Temp qw(tempdir);
use FindBin;
use lib "$FindBin::RealBin/../lib";

our $VERSION = '0.0.1';

BEGIN {
    if ( !eval { require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Mojolicious (Mojo::File / Mojo::JSON) is not installed';
    }
}

my $root    = "$FindBin::RealBin/..";
my $library = "$root/lib";
my $away    = tempdir( CLEANUP => 1 );

# Run a snippet in a pristine interpreter whose working directory is a
# temporary one, so nothing is resolved relative to the repository root and
# no module is already loaded.
sub run_detached {
    my ( $code, $environment ) = @_;

    my $command = sprintf 'cd %s && %s -I%s -e %s 2>&1',
        quotemeta $away, quotemeta $EXECUTABLE_NAME, quotemeta $library, quotemeta $code;

    # A registry pinned through the environment must not leak between cases,
    # and an inherited one must not silently satisfy a lookup under test.
    local %ENV = ( %ENV, %{ $environment || {} } );

    if ( !( $environment && $environment->{SPELLBOOK_MODULES} ) ) {
        delete $ENV{SPELLBOOK_MODULES};
    }

    # The whole point of this helper is a separate interpreter with its own
    # @INC and working directory, and the assertions read its combined
    # output, so a shell capture is what is wanted here.
    my $output = `$command`;    ## no critic (InputOutput::ProhibitBacktickOperator)
    chomp $output;

    return $output;
}

# A leaf module used entirely on its own: no dispatcher, no Getopt::Long
# loaded by anything else first.
my $leaf = run_detached(
    'require Spellbook::Helper::Normalize_Target;'
        . 'print join q{,}, Spellbook::Helper::Normalize_Target->new(["--target" => "https://example.com/a"]);'
);
is( $leaf, 'https://example.com/a', 'a leaf module runs when loaded on its own' );

# The catalogue is found even though the working directory has no .config.
# The snippet below is source for the child interpreter, so its sigils must
# stay literal rather than being interpolated here.
my $catalogue = run_detached(
    'require Spellbook::Core::Resources;'
        . 'print scalar @{ Spellbook::Core::Resources->new()->{modules} };'    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
);
like( $catalogue, qr/\A[1-9]\d*\z/msx, 'the catalogue is found from an unrelated directory' );

# The dispatcher works from an unrelated directory too.
my $dispatched = run_detached(
    'require Spellbook::Core::Module;'
        . 'print join q{}, sort split //, join q{}, Spellbook::Core::Module->new("Helper::Permutations", ["--value" => "abc"]);'
);
is( $dispatched, 'abc', 'the dispatcher runs a module from an unrelated directory' );

# Core::Search resolves the catalogue without the caller loading Resources.
my $searched = run_detached(
    'require Spellbook::Core::Search;'
        . 'Spellbook::Core::Search->new("permutations");'
);
like( $searched, qr/Helper::Permutations/msx, 'search resolves the catalogue on its own' );

# A name that is not in the catalogue at all reports "not found".
my $unknown = run_detached(
    'require Spellbook::Core::Module;'
        . 'print join q{}, Spellbook::Core::Module->new("Recon::NoSuchModule", []);'
);
like( $unknown, qr/Module[ ]not[ ]found/msx, 'a name absent from the catalogue reports "not found"' );

# A catalogue entry whose file is missing must also report "not found",
# rather than dying with a bare "Can't locate" out of require. This is the
# branch the one above never reaches, so it needs its own catalogue.
my $stale = "$away/stale-registry.json";
open my $stale_handle, '>', $stale or croak "Cannot write $stale: $OS_ERROR";
print {$stale_handle}
    '{"modules":[{"id":"0001","category":"recon","module":"Vanished","description":"file is gone"}]}';
close $stale_handle or croak "Cannot close $stale: $OS_ERROR";

my $vanished = run_detached(
    'require Spellbook::Core::Module;'
        . 'print join q{}, Spellbook::Core::Module->new("Recon::Vanished", []);',
    { SPELLBOOK_MODULES => $stale }
);
like( $vanished, qr/Module[ ]not[ ]found/msx, 'a catalogue row whose file is missing reports "not found"' );

# A module that exists but cannot be compiled must report the real reason
# instead of being mistaken for a missing one.
my $broken = "$away/broken-registry.json";
open my $broken_handle, '>', $broken or croak "Cannot write $broken: $OS_ERROR";
print {$broken_handle}
    '{"modules":[{"id":"0001","category":"android","module":"Schemes","description":"does not compile"}]}';
close $broken_handle or croak "Cannot close $broken: $OS_ERROR";

my $reported = run_detached(
    'require Spellbook::Core::Module;'
        . 'print join q{}, Spellbook::Core::Module->new("Android::Schemes", []);',
    { SPELLBOOK_MODULES => $broken }
);
unlike( $reported, qr/Module[ ]not[ ]found/msx, 'a module that fails to compile is not reported as missing' );
like( $reported, qr/Unable[ ]to[ ]load[ ]Android::Schemes/msx,
    'a module that fails to compile reports the real error' );

# Every catalogue entry must name a module that actually loads. Comparing
# against a directory listing rather than using -f keeps this honest on a
# case-insensitive filesystem, where -f matches Django_Debug against
# Django_DEBUG.pm and the drift only surfaces in Linux CI.
require Spellbook::Core::Resources;
my $resources = Spellbook::Core::Resources->new();
my ( %present, @missing, @unloadable );

for my $directory ( glob "$root/lib/Spellbook/*" ) {
    if ( !-d $directory ) {
        next;
    }

    my ($category) = $directory =~ m{([^/]+)\z}msx;
    opendir my $handle, $directory or next;

    for my $module ( map { s/[.]pm\z//msxr } grep { /[.]pm\z/msx } readdir $handle ) {
        $present{"$category/$module"} = 1;
    }

    closedir $handle or croak "Cannot close $directory: $OS_ERROR";
}

for my $entry ( @{ $resources->{modules} } ) {
    my $name = ucfirst( $entry->{category} ) . q{/} . $entry->{module};

    if ( !$present{$name} ) {
        push @missing, "$entry->{category}::$entry->{module}";
    }
}

is_deeply( \@missing, [], 'every catalogue entry names a module file that exists, matching case' );

# Existing on disk is not enough: the package inside has to match the path,
# or the dispatcher loads the file and then cannot call new on it.
for my $entry ( @{ $resources->{modules} } ) {
    my $package = 'Spellbook::' . ucfirst( $entry->{category} ) . q{::} . $entry->{module};
    my $output  = run_detached( "require $package; print $package->can('new') ? 'ok' : 'no-new';" );

    if ( $output ne 'ok' ) {
        push @unloadable, "$entry->{category}::$entry->{module}: $output";
    }
}

is_deeply( \@unloadable, [], 'every catalogue entry loads and exposes new()' );

done_testing();
