package Wlog::Data::Article;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;
use Wlog::Data::ArticleBody;
use Wlog::Data::ArticleBodyHistory;
use Wlog::Data::ArticleTag;
use Wlog::Data::CategoryTag;
use Wlog::Data::Tag;
use Array::Diff;
use URI::Escape;
use Wlog::DateTime;


__PACKAGE__->install_properties({
        columns     => [ qw/article_id category_id article_name on_blog bloged_at remote_user created_at updated_at/ ],
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

__PACKAGE__->add_trigger(
    post_remove => sub {
        my ( $obj ) = @_;
        my $body_obj = $obj->body_obj;
        my $article_tag_objs = $obj->article_tag_objs;
        my $data= $body_obj->as_fdat;
        my $body = delete $data->{body};
        $data->{compressed_body} = Wlog::Utils::compress( $body );
        my $history = Wlog::Data::ArticleBodyHistory->new( %$data ); 
        $history->save;
        $body_obj->remove;

        for(@$article_tag_objs){
            my $tag_obj = $_->tag_obj;
            $tag_obj->per_use( $_->per_use -1 );
            $tag_obj->save;
            $_->remove;
        }
    }
);

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

sub article_tag_objs {
    my $self = shift;
    my @article_tag_objs = Wlog::Data::ArticleTag->search( { article_id => $self->id } );
    return \@article_tag_objs;
}

sub category_tag_objs {
    my $self = shift;
    my @article_tag_objs = Wlog::Data::CategoryTag->search( { category_id => $self->category_id } );
    return \@article_tag_objs;
}

sub tag_update {
    my $self = shift;
    my $tags_array = shift || [];
    my $article_tag_objs = $self->article_tag_objs;  
    my @olds = map { $_->name } @$article_tag_objs;
    my $diff = Array::Diff->diff( \@olds, $tags_array );

    {
        my $deleted = $diff->deleted;
        if( scalar @$deleted ) {
            my @tags = Wlog::Data::Tag->search( { tag_name => $deleted } );
            my @tag_ids = map { $_->tag_id } @tags;
            Wlog::Data::ArticleTag->remove({  article_id => $self->id  , tag_id => \@tag_ids}) if scalar @tag_ids ;
            for(@tags){
                $_->per_use( $_->per_use - 1 );
                $_->save;
            }
        }
    } 

    {
        my $added = $diff->added;
        for(@$added){
            my $tag_obj = Wlog::Data::Tag->single_or_create( { tag_name => $_ } ); 
            my $article_tag_obj = Wlog::Data::ArticleTag->new( article_id => $self->id , tag_id => $tag_obj->id );
            $article_tag_obj->save;
            $tag_obj->per_use($tag_obj->per_use + 1 );
            $tag_obj->save;
        }
    }

}

sub article_url {
    my $self = shift;
    
    my @path = (
        $self->category_obj->key,
        URI::Escape::uri_escape_utf8( $self->name )
    );
    return '/' . join('/',@path ) ;
}

sub bloged_at_obj {
    my $self = shift;
    return Wlog::DateTime->parse('MySQL', $self->bloged_at );
}
1;
