package Wlog::Data::ArticleTag;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject);
use Wlog::ObjectDriver;
use Wlog::Data::Tag;
use Wlog::Data::CategoryTag;

__PACKAGE__->install_properties({
        columns     => [ qw/id article_id tag_id created_at updated_at/ ],
        datasource  => 'article_tag',
        primary_key => 'id',
        driver      => Wlog::ObjectDriver->driver,
        });


__PACKAGE__->has_a({
        class => 'Wlog::Data::Article',
        column => 'article_id',
        cached => 1,
        });

__PACKAGE__->add_trigger(
    post_remove => sub {
        my ( $obj ) = @_;
        my $category_tag_obj = $obj->category_tag_obj ;
        $category_tag_obj->per_use( $category_tag_obj->per_use -1 );
        $category_tag_obj->save;
    }
);

__PACKAGE__->add_trigger(
    post_insert => sub {
        my ( $obj ) = @_;
        my $category_tag_obj = $obj->category_tag_obj ;
        $category_tag_obj->per_use( $category_tag_obj->per_use + 1 );
        $category_tag_obj->save;
    }
);

sub tag_obj {
    my $self = shift;
    return Wlog::Data::Tag->lookup( $self->tag_id );
}
sub category_tag_obj {
    my $self = shift;
    return Wlog::Data::CategoryTag->single({ category_id => $self->article_obj->category_id , tag_id => $self->tag_id })
        || Wlog::Data::CategoryTag->new( category_id => $self->article_obj->category_id , tag_id => $self->tag_id ,per_use => 0) ;
}

sub name {
    my $self = shift;
    my $tag_obj = $self->tag_obj;
    return $tag_obj ? $tag_obj->name : '';
}

1;
