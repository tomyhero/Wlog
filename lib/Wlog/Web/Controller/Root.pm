package Wlog::Web::Controller::Root;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->namespace('');

use Wlog::Text;
use Polocky::Utils;
use IO::All;

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my $wiki = Wlog::Text->new();
    my $file = Polocky::Utils::path_to( 'misc/article.txt');
    my $text = io( $file )->utf8->all;
    my $article = $wiki->parse( $text);
    $c->stash->{article} = $article;
}

sub end  :ActionClass('RenderView') {}

__POLOCKY__;
