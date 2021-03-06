package Wlog::Data::Tag;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject);
use Wlog::ObjectDriver;
use URI::Escape;

__PACKAGE__->install_properties({
        columns     => [ qw/tag_id tag_name per_use created_at updated_at/ ],
        datasource  => 'tag',
        primary_key => 'tag_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->setup_alias({
        id => 'tag_id',
        name => 'tag_name',
        });

sub default_values {
    +{
        per_use => 0,
    }
}

sub url {
    my $self = shift;
    return sprintf('/tag/%s/',uri_escape_utf8($self->name) );
}
1;
