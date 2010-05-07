package Wlog::Web::Controller::CMS::Category::Article;
use Polocky::Class;
use Wlog::DateTime;

__PACKAGE__->path_part( 'cms/category/article' );
__PACKAGE__->entry_obj( 'Wlog::Data::Article' );

__PACKAGE__->profile_for_edit(
        +{
            required => [qw/body publish_blog/],
            optional => [qw/tags/],
            defaults => {
                publish_blog => 0,
            },
            use_fixed_method => {
                tags => 'tags_array',
            }
        }
        );

BEGIN { extends 'Wlog::WAF::CatalystLike::Controller::CMS' };

sub endpoint :Chained('/cms/category/endpoint_category') :PathPart('article') :CaptureArgs(1) {
    my ($self, $c, $id ) = @_;
    my $entry_obj = $self->entry_obj->lookup( $id ) or $c->detach('/error');
    $c->stash->{entry_obj} = $entry_obj;
    return 1;
}

sub add : Chained('/cms/category/endpoint') :PathPart('article/add') {
    my ( $self, $c ) = @_;
    if( $c->req->method eq 'POST' ) {
        $c->detach('do_add');
    }
    my $form = $c->form( { required => qw/article_name/ } );
    if( $form->has_error ) {
        $c->detach('/error');
    }
}

sub do_add : Private {
    my ( $self, $c ) = @_;
    my $profile = $self->profile_for_edit ;
    push @{$profile->{required}}, 'article_name' ;
    my $form = $c->form( $profile );
    if( $form->has_error ) {
        return ;
    }
    my $category_obj =  $c->stash->{entry_obj};
    my $v = $form->valid;
    my $article_obj;
    {
        my $data = {};
        if( $v->{publish_blog} ) {
            $data->{on_blog} = 1;
            $data->{bloged_at} =   Wlog::DateTime->sql_now ;
        }
        else {
            $data->{on_blog} = 0;
        }
        $data->{article_name} = $v->{article_name};
        $data->{category_id} = $category_obj->id;
        my $entry_obj = $self->entry_obj->new( %$data );
        $entry_obj->save();
        $article_obj = $entry_obj;
    }

    {
        my $article_body_obj = Wlog::Data::ArticleBody->new( article_id => $article_obj->id ,body => $v->{body} );
        $article_body_obj->save();
    }

    {
        my $tags_array = $form->fixed->{'tags_array'} || [];
        $article_obj->tag_update( $tags_array );
    }

    $c->redirect( $c->req->uri_build([ $category_obj->key , $article_obj->name ]) );

}


sub edit : Chained('endpoint') :PathPart('edit') {
    my ( $self, $c ) = @_;
    $c->stash->{template} = $self->path_part . '/edit.tt';

    my $entry_obj = $c->stash->{entry_obj};
    my $body_obj = Wlog::Data::ArticleBody->lookup($entry_obj->id);

    my $tag_objs = $entry_obj->tag_objs;
    my @tags = map{ $_->name } @$tag_objs;
    my $tags = join(' ',@tags);

    my $fdat = $entry_obj->as_fdat;
    $fdat->{body} =  $body_obj->body;
    $fdat->{tags} =  $tags;
    $c->set_fillform( $fdat );

    if( $c->req->method eq 'POST' ) {
        $c->forward('do_edit');
    }
}

sub do_edit : Private {
    my ( $self, $c) = @_;
    my $entry_obj = $c->stash->{entry_obj};

    my $form = $c->form( $self->profile_for_edit );

    if( $form->has_error ) {
        return ;
    }

    my $category_obj = $entry_obj->category_obj;
    my $article_body_obj = $entry_obj->body_obj;

    my $v = $form->valid;
    {
        my $data = {};
        if( $v->{publish_blog} ) {
            $data->{on_blog} = 1;
            $data->{bloged_at} =   Wlog::DateTime->sql_now ;
        }

        $entry_obj->update_from_v($data);
        $entry_obj->save();
    }

    {
        $article_body_obj->body( $v->{body} );
        $article_body_obj->save();
    }

    {
        my $tags_array = $form->fixed->{'tags_array'} || [];
        $entry_obj->tag_update( $tags_array );
    }

    $c->redirect( $c->req->uri_build([ $category_obj->key , $entry_obj->name ]) );

}
__POLOCKY__;
