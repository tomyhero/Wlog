package Wlog::CMS::Controller::Root;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->namespace('');

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{name} = 'Wlog::CMS';
}

sub end  :ActionClass('RenderView') {}

__POLOCKY__;
