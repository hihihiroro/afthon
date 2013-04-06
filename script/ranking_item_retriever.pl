#!/usr/bin/perl

use strict;
use warnings;
use utf8;
binmode(STDOUT, ":utf8");
use FindBin;
use File::Spec;
use File::Slurp;
use lib File::Spec->catdir($FindBin::Bin, File::Spec->updir(), 'lib');
use Data::Dumper;
use POSIX;
use Getopt::Long;
use Pod::Usage;
use URI::Afthon::ItemSearch;

my $search = URI::Afthon::ItemSearch->new(
    'affiliateId' => '11068980.9df881e7.11068981.510ea67c',
);
$search->search(genreId => '100433');

1;

