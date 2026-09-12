#!/usr/bin/env perl

# Spellbook::Core::Search scans the module catalogue, prints every module
# whose metadata contains the search term, and returns the list of extra
# arguments it was given untouched.

use strict;
use warnings;

use Carp;
use English qw(-no_match_vars);
use Test::More;
use FindBin;
use lib "$FindBin::RealBin/../lib";

our $VERSION = '0.0.1';

chdir "$FindBin::RealBin/.." or croak "Unable to chdir to repository root: $OS_ERROR";

BEGIN {
    if ( !eval { require Readonly; require Mojo::File; require Mojo::JSON; 1 } ) {
        plan skip_all => 'Readonly / Mojolicious are not installed';
    }
}

require Spellbook::Core::Search;

sub capture_search {
    my (@arguments) = @_;

    my $output = q{};
    my @return;
    {
        open my $capture, '>', \$output or croak "Cannot open in-memory handle: $OS_ERROR";

        # One-argument select is the standard idiom for redirecting the
        # default output handle so the module's prints land in $output.
        my $previous = select $capture;  ## no critic (InputOutput::ProhibitOneArgSelect)
        @return = Spellbook::Core::Search->new(@arguments);
        select $previous;  ## no critic (InputOutput::ProhibitOneArgSelect)
        close $capture or croak "Cannot close in-memory handle: $OS_ERROR";
    }

    return ( $output, \@return );
}

# A matching term prints the catalogue entries it hits.
my ( $matched_output, undef ) = capture_search('recon');
like( $matched_output, qr/Module:/msx,      'matching search prints a module header' );
like( $matched_output, qr/Recon::/imsx,     'matching search prints the recon category' );
like( $matched_output, qr/Description:/msx,  'matching search prints a description' );

# A term that matches nothing prints nothing, and the extra arguments are
# returned unchanged.
my ( $empty_output, $passthrough ) = capture_search( 'zzz-no-such-module', 'a', 'b' );
is( $empty_output, q{}, 'a non-matching search prints nothing' );
is_deeply( $passthrough, [ 'a', 'b' ], 'extra arguments are returned untouched' );

done_testing();
