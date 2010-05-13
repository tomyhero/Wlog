package Wlog::Data::ArticleBody;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;
use Wlog::Utils;
use Wlog::Data::Article;
use Wlog::Data::ArticleBodyHistory;

__PACKAGE__->install_properties({
        columns     => [ qw/article_id remote_user body version created_at updated_at/ ],
        datasource  => 'article_body',
        primary_key => 'article_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->add_trigger(
    pre_update => sub {
        my ( $obj, $orig_obj ) = @_;
        my $current_obj = Wlog::Data::ArticleBody->lookup( $obj->id );
        my $data = $current_obj->as_fdat;
        my $body = delete $data->{body};
        $data->{compressed_body} = Wlog::Utils::compress( $body );
        my $body_obj = Wlog::Data::ArticleBodyHistory->new( %$data );
        $body_obj->save;
    }
);
__PACKAGE__->install_plugins([qw/Article/]);

__PACKAGE__->setup_alias({
        id => 'article_id',
});

sub default_values {
    +{
        version => 1,
    }
}

sub article_obj {
    my $self = shift;
    my $obj = Wlog::Data::Article->lookup( $self->id ); 
    return $obj;
}

sub category_obj {
    my $self = shift;
    my $obj = Wlog::Data::Category->lookup( $self->article_obj->category_id ); 
    return $obj;
}

1;
