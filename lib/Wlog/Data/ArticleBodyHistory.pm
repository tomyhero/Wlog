package Wlog::Data::ArticleBodyHistory;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject);
use Wlog::ObjectDriver;


__PACKAGE__->install_properties({
        columns     => [ qw/article_body_history_id article_id version remote_user compressed_body created_at updated_at/ ],
        datasource  => 'article_body_history',
        primary_key => 'article_body_history_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->setup_alias({
        id => 'article_body_history_id',
        });

__PACKAGE__->has_a({
        class => 'Wlog::Data::Article',
        column => 'article_id',
        cached => 1,
        });


1;
