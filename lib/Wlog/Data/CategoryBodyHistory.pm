package Wlog::Data::CategoryBodyHistory;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject);
use Wlog::ObjectDriver;


__PACKAGE__->install_properties({
        columns     => [ qw/category_body_history_id category_id version remote_user compressed_body created_at updated_at/ ],
        datasource  => 'category_body_history',
        primary_key => 'category_body_history_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->setup_alias({
        id => 'category_body_history_id',
        });

__PACKAGE__->has_a({
        class => 'Wlog::Data::Category',
        column => 'category_id',
        cached => 1,
        });


1;
