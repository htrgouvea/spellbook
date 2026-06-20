#!/usr/bin/env perl

# Spellbook::Core::Search scans the module catalogue, prints every module
# whose metadata contains the search term, and returns the list of extra
# arguments it was given untouched.

use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

# Search resolves the catalogue through Resources, which reads
# .config/modules.json relative to the current directory.
chdir "$FindBin::RealBin/.." or die "Unable to chdir to repository root: $!";

BEGIN {
    unless ( eval { require Readonly; require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Readonly / Mojolicious are not installed';
    }
}

# Search calls Spellbook::Core::Resources at runtime without loading it
# itself, so it must already be available.
require Spellbook::Core::Resources;
require Spellbook::Core::Search;

sub capture_search {
    my (@arguments) = @_;

    my $output = q{};
    my @return;
    {
        open my $capture, '>', \$output or die "Cannot open in-memory handle: $!";
        my $previous = select $capture;
        @return = Spellbook::Core::Search->new(@arguments);
        select $previous;
        close $capture;
    }

    return ( $output, \@return );
}

# A matching term prints the catalogue entries it hits.
my ( $matched_output, undef ) = capture_search('recon');
like( $matched_output, qr/Module:/,      'matching search prints a module header' );
like( $matched_output, qr/Recon::/i,     'matching search prints the recon category' );
like( $matched_output, qr/Description:/,  'matching search prints a description' );

# A term that matches nothing prints nothing, and the extra arguments are
# returned unchanged.
my ( $empty_output, $passthrough ) = capture_search( 'zzz-no-such-module', 'a', 'b' );
is( $empty_output, q{}, 'a non-matching search prints nothing' );
is_deeply( $passthrough, [ 'a', 'b' ], 'extra arguments are returned untouched' );

done_testing();
