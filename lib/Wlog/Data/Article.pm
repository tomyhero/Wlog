package Wlog::Data::Article;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;
use Wlog::Data::ArticleBody;

__PACKAGE__->install_properties({
        columns     => [ qw/article_id category_id article_name on_blog bloged_at created_at updated_at/ ],
        datasource  => 'article',
        primary_key => 'article_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->setup_alias({
        id => 'article_id',
        name => 'article_name',
        });

__PACKAGE__->has_a({
        class => 'Wlog::Data::Category',
        column => 'category_id',
        cached => 1,
        });

sub body_obj {
    my $self = shift;
    my $obj = Wlog::Data::ArticleBody->lookup( $self->id ); 
    return $obj;
}

sub article {
    my $self = shift;
    my $body_obj = $self->body_obj;
    if( $body_obj){
        return $body_obj->article ;
    }
    else {
        return '';
    }
}

1;
