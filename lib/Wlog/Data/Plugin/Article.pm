package Wlog::Data::Plugin::Article;
use warnings;
use strict;
use Wlog::Text;
use base qw(Wlog::Data::Plugin::Base);
__PACKAGE__->methods([qw/article/]);

sub article {
    my $self = shift;
    my $wiki = Wlog::Text->instance();
    $wiki->parse( $self->body || '' , { category_obj => $self->category_obj } ) ;
}

1;
