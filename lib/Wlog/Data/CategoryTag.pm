package Wlog::Data::CategoryTag;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject);
use Wlog::ObjectDriver;
use Wlog::Data::Tag;

__PACKAGE__->install_properties({
        columns     => [ qw/id category_id tag_id per_use created_at updated_at/ ],
        datasource  => 'category_tag',
        primary_key => 'id',
        driver      => Wlog::ObjectDriver->driver,
        });

sub tag_obj {
    my $self = shift;
    return Wlog::Data::Tag->lookup( $self->tag_id );
}

sub name {
    my $self = shift;
    my $tag_obj = $self->tag_obj;
    return $tag_obj ? $tag_obj->name : '';
}

1;
