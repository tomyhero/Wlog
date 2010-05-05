package Wlog::Web::Controller::Root;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->namespace('');

use Wlog::Text;
use Polocky::Utils;
use IO::All;
use Wlog::Data::Category;

sub auto : Private {
    my ( $self, $c ) = @_;
    my @category_objs = Wlog::Data::Category->search();
    $c->stash->{category_objs} = \@category_objs;
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my $wiki = Wlog::Text->new();
    my $file = Polocky::Utils::path_to( 'misc/article.txt');
    my $text = io( $file )->utf8->all;
    my $article = $wiki->parse( $text);
    $c->stash->{article} = $article;
}

sub category : LocalRegex('([a-zA-Z0-9_-]+)') {
    my ( $self, $c ) = @_;
    # for testing

    $c->stash->{template} = 'index.tt';
    $c->detach('index');
}

sub end  :ActionClass('RenderView') {}

__POLOCKY__;
