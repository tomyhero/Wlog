package Wlog::Data::CategoryBody;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;

__PACKAGE__->install_properties({
        columns     => [ qw/category_id body created_at updated_at/ ],
        datasource  => 'category_body',
        primary_key => 'category_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->install_plugins([qw/Article/]);

1;