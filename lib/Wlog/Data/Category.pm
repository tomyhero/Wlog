package Wlog::Data::Category;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;

__PACKAGE__->install_properties({
        columns     => [ qw/category_id category_key category_name created_at updated_at/ ],
        datasource  => 'category',
        primary_key => 'category_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->setup_alias({
        id => 'category_id',
        key => 'category_key',
        name => 'category_name',
        });

1;
