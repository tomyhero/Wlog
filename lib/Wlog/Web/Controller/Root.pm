package Wlog::Web::Controller::Root;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->namespace('');

use Wlog::Text;
use Polocky::Utils;
use IO::All;
use Wlog::Data::Category;
use Wlog::Data::Article;
use Wlog::Constants qw(:common);

sub auto : Private {
    my ( $self, $c ) = @_;
    my @category_objs = Wlog::Data::Category->search();
    $c->stash->{category_objs} = \@category_objs;
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my @article_objs 
        = Wlog::Data::Article->search(
            {
                on_blog => TRUE, 
            },{
                sort => 'bloged_at',
                direction => 'descend',
                limit => 3,
            }
            );
    $c->stash->{article_objs} = \@article_objs;
}

sub category : LocalRegex('([a-zA-Z0-9_-]+)$') {
    my ( $self, $c ) = @_;
    $c->forward('preapre_category');
}
sub preapre_category : Private {
    my ( $self, $c ) = @_;
    my $key = $c->req->captures->[0];
    my $category_obj = Wlog::Data::Category->single( { category_key => $key } );
    $c->stash->{category_obj} = $category_obj;
    $c->stash->{article} = $category_obj->article ;

    my @article_objs = Wlog::Data::Article->search( 
        { category_id => $category_obj->id },
        {
            sort => 'updated_at',
            direction => 'descend',
            limit => 10,
        }
    );
    $c->stash->{article_objs} = \@article_objs;
}

sub article :  LocalRegex('([a-zA-Z0-9_-]+)/(.+)') {
    my ( $self, $c ) = @_;
    $c->forward('preapre_category');
    my $name =$c->req->captures->[1];
    my $article_obj = Wlog::Data::Article->single( { article_name => $name } );
    $c->stash->{article_obj} = $article_obj;
}

sub end  :ActionClass('RenderView') {}

__POLOCKY__;
