package Wlog::ObjectDriver;
use warnings;
use strict;
use Data::ObjectDriver::Driver::DBI;
use Wlog::Config;

sub driver {
    my $self = shift;
    my $config = Wlog::Config->instance->database;
    Data::ObjectDriver::Driver::DBI->new( %$config );
}

1;
