#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use Pithub::Issues;
use Perl::Critic;
use Path::Iterator::Rule;

sub report {
    my $pithub = Pithub::Issues -> new();

    my $result = $pithub -> create (
        user => 'GouveaHeitor',
        repo => 'spellbook',
        token => '327945b2687b88dfdf44a4784ca0284d2598e927',
        data => {
            assignee  => 'octocat', 
            body      => "I'm having a problem with this.",
            labels    => [ 'Label1', 'Label2' ],
            milestone => 1,
            title     => 'Found a bug'
        }
    );

    return 1;
}

report();

my $rule = Path::Iterator::Rule -> new();
my @files = $rule -> all(my @dirs);

for my $file ($rule -> all(@dirs)) {
    if (($file =~ m/\.pl/i) || ($file =~ m/\.pm/i))  {
        my $critic     = Perl::Critic -> new();
        my @violations = $critic -> critique($file);

        if (@violations) {
            print "
                \r[-] $file
                \r[+] @violations
            \r"; 
        }
    }
}
    
print "Ok\n";
exit;