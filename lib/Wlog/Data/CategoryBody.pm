package Wlog::Data::CategoryBody;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;
use Wlog::Data::Category;
use Wlog::Data::CategoryBodyHistory;
use Wlog::Utils;

__PACKAGE__->install_properties({
        columns     => [ qw/category_id remote_user body version created_at updated_at/ ],
        datasource  => 'category_body',
        primary_key => 'category_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->add_trigger(
    pre_update => sub {
        my ( $obj, $orig_obj ) = @_;
        my $current_obj = Wlog::Data::CategoryBody->lookup( $obj->id );
        my $data = $current_obj->as_fdat;
        my $body = delete $data->{body};
        $data->{compressed_body} = Wlog::Utils::compress( $body );
        #warn Wlog::Utils::uncompress($data->{compressed_body});

        my $category_body_obj = Wlog::Data::CategoryBodyHistory->new( %$data );
        $category_body_obj->save;
    }
);

__PACKAGE__->install_plugins([qw/Article/]);

__PACKAGE__->setup_alias({
        id => 'category_id',
});

sub default {
    +{
        version => 1,
    }
}

sub category_obj {
    my $self = shift;
    my $obj = Wlog::Data::Category->lookup( $self->id ); 
    return $obj;
}

1;
