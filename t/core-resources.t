#!/usr/bin/env perl

# Spellbook::Core::Resources loads .config/modules.json and exposes the
# module catalogue as a hash reference.

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

# Resources reads .config/modules.json relative to the current directory.
chdir "$FindBin::RealBin/.." or die "Unable to chdir to repository root: $!";

BEGIN {
    unless ( eval { require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Mojolicious (Mojo::File / Mojo::JSON) is not installed';
    }
}

require Spellbook::Core::Resources;

my $resources = Spellbook::Core::Resources->new();

is( ref $resources,             'HASH',  'new() returns a hash reference' );
is( ref $resources->{modules},  'ARRAY', 'the catalogue is an array reference' );
ok( scalar @{ $resources->{modules} } > 0, 'the catalogue is not empty' );

# Every entry should describe a category and a module name.
my $well_formed = 1;
for my $entry ( @{ $resources->{modules} } ) {
    unless ( ref $entry eq 'HASH'
        && defined $entry->{category}
        && defined $entry->{module} ) {
        $well_formed = 0;
        last;
    }
}
ok( $well_formed, 'every catalogue entry has a category and a module' );

done_testing();
