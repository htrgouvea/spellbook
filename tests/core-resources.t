#!/usr/bin/env perl

# Spellbook::Core::Resources loads .config/modules.json and exposes the
# module catalogue as a hash reference.

use strict;
use warnings;

use Carp;
use English qw(-no_match_vars);
use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

our $VERSION = '0.0.1';

# Resources prefers .config/modules.json relative to the current directory,
# falling back to the copy shipped alongside lib/.
chdir "$FindBin::RealBin/.."
    or croak "Unable to chdir to repository root: $OS_ERROR";

BEGIN {
    if ( !eval { require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Mojolicious (Mojo::File / Mojo::JSON) is not installed';
    }
}

require Spellbook::Core::Resources;

my $resources = Spellbook::Core::Resources->new();

is( ref $resources,            'HASH',  'new() returns a hash reference' );
is( ref $resources->{modules}, 'ARRAY', 'the catalogue is an array reference' );
ok( scalar @{ $resources->{modules} } > 0, 'the catalogue is not empty' );

# Every entry should describe a category and a module name.
my $well_formed = 1;
for my $entry ( @{ $resources->{modules} } ) {
    if ( !( ref $entry eq 'HASH'
            && defined $entry->{category}
            && defined $entry->{module} ) ) {
        $well_formed = 0;
        last;
    }
}
ok( $well_formed, 'every catalogue entry has a category and a module' );

done_testing();
