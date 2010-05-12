package Wlog::Data::ArticleBody;
use strict;
use warnings;
use base qw(Wlog::Data::BaseObject );
use Wlog::ObjectDriver;
use Wlog::Utils;
use Wlog::Data::ArticleBodyHistory;

__PACKAGE__->install_properties({
        columns     => [ qw/article_id remote_user body version created_at updated_at/ ],
        datasource  => 'article_body',
        primary_key => 'article_id',
        driver      => Wlog::ObjectDriver->driver,
        });

__PACKAGE__->add_trigger(
    pre_update => sub {
        my ( $obj, $orig_obj ) = @_;
        my $current_obj = Wlog::Data::ArticleBody->lookup( $obj->id );
        my $data = $current_obj->as_fdat;
        my $body = delete $data->{body};
        $data->{compressed_body} = Wlog::Utils::compress( $body );
        #warn Wlog::Utils::uncompress($data->{compressed_body});

        my $category_body_obj = Wlog::Data::ArticleBodyHistory->new( %$data );
        $category_body_obj->save;
    }
);
__PACKAGE__->install_plugins([qw/Article/]);

__PACKAGE__->setup_alias({
        id => 'article_id',
});

sub default_values {
    +{
        version => 1,
    }
}

1;
