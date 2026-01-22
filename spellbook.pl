use 5.030;
use strict;
use warnings;
use Find::Lib './lib';
use Spellbook::Core::Helper;
use Spellbook::Core::Search;
use Spellbook::Core::Module;
use Getopt::Long qw(:config no_ignore_case pass_through);

our $VERSION = '0.0.1';

sub main {
    my ($search, $module, @result);

    Getopt::Long::GetOptions (
        's|search=s' => \$search,
        'm|module=s' => \$module
    );

    if ($search) {
        @result = Spellbook::Core::Search -> new($search);
    }

    if ($module) {
        @result = Spellbook::Core::Module -> new($module, \@ARGV);
    }

    foreach my $item (@result) {
        print $item, "\n";
    }

    if (!$search && !$module) {
        return Spellbook::Core::Helper -> new();
    }

    return 0;
}

main();
