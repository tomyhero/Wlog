package Wlog::Data::Plugin::PSON;
use warnings;
use strict;
use Acme::PSON qw(obj2pson pson2obj);
use base qw(Wlog::Data::Plugin::Base);
__PACKAGE__->methods([qw/pson_obj/]);
sub pson_obj {
    my $self= shift;
    return pson2obj( $self->pson || '{}' );
}
1;
