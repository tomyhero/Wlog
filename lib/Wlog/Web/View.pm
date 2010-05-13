package Wlog::Web::View;
use Polocky::Class;
extends 'Polocky::WAF::View';
use Wlog::Resource;

sub _build_stash {
    my ( $self, $c, $type ) = @_;
    $c->stash->{c} = $c;
    $c->stash->{config} = $c->config;
    $c->stash->{resource} = Wlog::Resource->new;
}

__POLOCKY__;
