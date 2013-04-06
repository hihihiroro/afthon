package Rankdata;

use strict;
use warnings;
use utf8;
use open OUT => qw/:utf8 :std/;

our $VERSION = '0.01';

use MongoDB;

sub new {
  my ($class, %options) = @_;
  my $self = {};
  bless $self, $class;
}

sub getItems {
    my $client     = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    my $database   = $client->get_database( 'afthon' );
    my $collection = $database->get_collection( 'search' );
    my $data       = $collection->find_one(); #->sort({_id => -1});

    my $ref = $data->{Item};
    return $ref; 
}

1;
