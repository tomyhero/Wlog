package Wlog::Data::Category;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;
use Wlog::Data::CategoryBody;
use Wlog::Data::Sidebar;
use Wlog::Sidebar;

__PACKAGE__->install_properties({
        columns     => [ qw/category_id category_key category_name sort remote_user created_at updated_at/ ],
        datasource  => 'category',
        primary_key => 'category_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->setup_alias({
        id => 'category_id',
        key => 'category_key',
        name => 'category_name',
        });

__PACKAGE__->add_trigger(
    post_insert => sub {
        my ( $obj ) = @_;
        my $category_body_obj = Wlog::Data::CategoryBody->new();
        $category_body_obj->category_id( $obj->id );
        $category_body_obj->remote_user( $obj->remote_user );
        $category_body_obj->body( "TOP PAGE" );
        $category_body_obj->save(); 
    }
);

sub body_obj {
    my $self = shift;
    my $obj = Wlog::Data::CategoryBody->lookup( $self->id ); 
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

sub sidebar_objs {
    my $self = shift;
    my @sidebar_objs = Wlog::Data::Sidebar->search( { category_id => $self->id } , { sort => 'sort' , direction => 'descend' } );
    return \@sidebar_objs;
}

1;
