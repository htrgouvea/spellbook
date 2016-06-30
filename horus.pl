#!/usr/bin/perl

use 5.010;
use Switch;
use strict;
use warnings;
use lib "./lib/";
use Horus::Cripto;
use Horus::Create;
use Horus::Connect;
use Horus::Functions;

my $command = $ARGV[0];

Horus::Functions -> banner();

switch ($command) {
	case "--create" {
		Horus::Create -> new();
	}

	case "--connect" {
		Horus::Connect -> new();
	}

	case "--install" {
		Horus::Functions -> install();
	}

	else {
		Horus::Functions -> help();
	}
}

exit;