package Wlog::Data::ArticleTag;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject);
use Wlog::ObjectDriver;
use Wlog::Data::Tag;

__PACKAGE__->install_properties({
        columns     => [ qw/id article_id tag_id created_at updated_at/ ],
        datasource  => 'article_tag',
        primary_key => 'id',
        driver      => Wlog::ObjectDriver->driver,
        });

sub tag_obj {
    my $self = shift;
    return Wlog::Data::Tag->lookup( $self->tag_id );
}
#__PACKAGE__->has_a({
#        class => 'Wlog::Data::Tag',
#        column => 'tag_id',
#        cached => 1,
#        });


sub name {
    my $self = shift;
    my $tag_obj = $self->tag_obj;
    return $tag_obj ? $tag_obj->name : '';
}

1;
