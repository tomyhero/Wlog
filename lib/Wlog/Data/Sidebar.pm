package Wlog::Data::Sidebar;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;

__PACKAGE__->install_properties({
        columns     => [ qw/sidebar_id article_id sidebar_plugin sidebar_name sort pson created_at updated_at/ ],
        datasource  => 'sidebar',
        primary_key => 'sidebar',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->install_plugins([qw/PSON/]);

__PACKAGE__->setup_alias({
        id => 'sidebar_id',
        plugin => 'sidebar_plugin',
        name => 'sidebar_name',
        });

1;
