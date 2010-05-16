package Wlog::Web::Controller::Root;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->namespace('');

use Wlog::Text;
use Polocky::Utils;
use IO::All;
use Wlog::Data::Category;
use Wlog::Data::Article;
use Wlog::Data::ArticleTag;
use Wlog::Constants qw(:common);
use Wlog::Pager;
use XML::RSS;

sub auto : Private {
    my ( $self, $c ) = @_;
    # XXX skip this code at /cms/
    my @category_objs = Wlog::Data::Category->search( {} ,{ sort => 'sort' , direction => 'descend' } );
    $c->stash->{category_objs} = \@category_objs;
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'index.tt';
    my $pager = Wlog::Pager->new;
    $pager->entries_per_page(3);
    $pager->current_page( $c->req->param('p') || 1 );
    $pager->uri($c->req->uri);

    my @article_objs 
        = Wlog::Data::Article->search(
            {
                on_blog => TRUE, 
            },{
                sort => 'bloged_at',
                direction => 'descend',
                pager => $pager
            }
            );
    $c->stash->{pager} = $pager;
    $c->stash->{article_objs} = \@article_objs;
    $c->stash->{category_obj} = Wlog::Data::Category->new( id => 0 );
}
sub feed : Local {
    my ( $self, $c ) = @_;

    my @article_objs 
        = Wlog::Data::Article->search(
            {
                on_blog => TRUE, 
            },{
                sort => 'bloged_at',
                direction => 'descend',
                limit => 10,
            }
            );

    my $rss = XML::RSS->new(version => '1.0');
    $rss->channel( title => $c->config->site('title') );
    for(@article_objs){
        my $url = $c->req->base;
        $url =~ s/\/$//;
        $url .=  $_->article_url;
        $rss->add_item( title => $_->name  , link => $url , description => $_->article , dc => { date => $_->bloged_at_obj->strftime("%Y-%m-%dT%T+09:00") } );
    }

    if( my $xml = $rss->as_string ) {
        $c->res->code(200);
        $c->res->content_type('application/rss+xml');
        $c->res->body( $xml );
    }
    else {
        $c->detach('error');
    }
}

sub tag : LocalRegex('tag/(.+)') {
    my ( $self, $c ) = @_;
    my $name = $c->req->captures->[0];
    my $tag_obj = Wlog::Data::Tag->single({tag_name => $name }) or $c->detach('/error');
    $c->stash->{tag_obj} = $tag_obj;

    my @article_tag_objs = Wlog::Data::ArticleTag->search({ tag_id => $tag_obj->id },{limit => 200 });
    my @article_ids = map { $_->article_id } @article_tag_objs;
    my $article_objs = Wlog::Data::Article->lookup_multi(\@article_ids );
    $c->stash->{article_objs} = $article_objs;
    $c->stash->{category_obj} = Wlog::Data::Category->new( id => 0 );

}
sub category : LocalRegex('(^(?!cms|tag|feed|api)[a-zA-Z0-9_-]+)$') {
    my ( $self, $c ) = @_;
    $c->forward('preapre_category');
}
sub preapre_category : Private {
    my ( $self, $c ) = @_;
    my $key = $c->req->captures->[0];
    my $category_obj = Wlog::Data::Category->single( { category_key => $key } )  or $c->detach('/error');
    $c->stash->{category_obj} = $category_obj;
    $c->stash->{article} = $category_obj->article ;
}

sub article :  LocalRegex('(^(?!cms|tag|feed|api)[a-zA-Z0-9_-]+)/(.+)') {
    my ( $self, $c ) = @_;
    $c->forward('preapre_category');
    my $name =$c->req->captures->[1];
    my $article_obj = Wlog::Data::Article->single( { article_name => $name } );
    $c->stash->{article_obj} = $article_obj;
    
}

sub error : Private {
    my ( $self, $c ) = @_;
    $c->res->status(500);    
    $c->res->body('-_-');
}

sub end  :ActionClass('RenderView') {}

__POLOCKY__;
