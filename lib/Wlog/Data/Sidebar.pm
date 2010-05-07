package Wlog::Data::Sidebar;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;
use Acme::PSON qw(pson2obj);

__PACKAGE__->install_properties({
        columns     => [ qw/sidebar_id category_id sidebar_plugin sort pson created_at updated_at/ ],
        datasource  => 'sidebar',
        primary_key => 'sidebar_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->install_plugins([qw/PSON/]);

__PACKAGE__->setup_alias({
        id => 'sidebar_id',
        plugin => 'sidebar_plugin',
        name => 'sidebar_name',
        });


sub pson_data {
    my $self = shift;
    return pson2obj( $self->pson );
}

1;
