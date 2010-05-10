package Wlog::Data::ArticleBody;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;

__PACKAGE__->install_properties({
        columns     => [ qw/article_id remote_user body created_at updated_at/ ],
        datasource  => 'article_body',
        primary_key => 'article_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->install_plugins([qw/Article/]);

1;
