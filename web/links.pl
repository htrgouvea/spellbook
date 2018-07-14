#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use URI;
use WWW::Mechanize;

sub main {
  my $target = $ARGV[0];

  if ($target) {
    if ($target !~ /^https?:/) {
      $target = 'http://' . $target;
    }

    my @urls = $target;
    my %seen = ();
    my @links = ();

    while (my $link = shift @urls) {
      next if $seen{$link}++;

      print $link . "\n";

      my $host = URI -> new($link) -> host();

      my $mech = WWW::Mechanize -> new();

      eval {
        $mech -> get($link);
      };

      return if ($@);

      my @links = $mech -> links();
      my %seen = ();

      foreach my $uri (@links) {
        my $url = $uri -> url_abs();
        next if $url eq $link;
        my $hurl;

        eval { $hurl = URI -> new($url) -> host(); };

        next unless $hurl;

        if ($hurl =~ $host) {
          next if $seen{$url}++;
        }
      }

      @links = keys %seen;

      push @urls, @links;
    }
  }
}

main();
exit;
