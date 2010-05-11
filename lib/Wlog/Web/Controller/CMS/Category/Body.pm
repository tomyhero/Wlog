package Wlog::Web::Controller::CMS::Category::Body;
use Polocky::Class;
use Wlog::Data::CategoryBody;
BEGIN { extends 'Wlog::WAF::CatalystLike::Controller::CMS' };

__PACKAGE__->path_part( 'cms/category/body' );
__PACKAGE__->entry_obj( 'Wlog::Data::CategoryBody' );
__PACKAGE__->profile_for_edit(
        +{
            required => [qw/body/]
        }
        );

sub endpoint :Chained('/') :PathPart('cms/category/body') :CaptureArgs(1) {
    my ($self, $c, $id ) = @_;
    my $entry_obj = $self->entry_obj->lookup( $id ) or $c->detach('/error');
    $c->stash->{entry_obj} = $entry_obj;
    return 1;
}

sub after_edit : Private {
    my ($self, $c ) = @_;
    my $category_body_obj= $c->stash->{entry_obj};
    my $category_obj = $category_body_obj->category_obj;
    $c->redirect('/' . $category_obj->category_key .'/' );
}

sub do_edit : Private {
    my ( $self, $c) = @_;
    my $entry_obj = $c->stash->{entry_obj};
    my $form = $c->form( $self->profile_for_edit );

    if( $form->has_error ) {
        return ;
    }
    my $v = $form->valid;
    $v->{remote_user} = $c->req->user;
    $v->{version} = $entry_obj->version + 1;
    $entry_obj->update_from_v( $v );
    $entry_obj->save();
    $c->forward('after_edit');
}
__POLOCKY__;
