package Wlog::WAF::CatalystLike::Controller::CMS;
use Polocky::Class;

BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

__PACKAGE__->mk_classdata('entry_obj');
__PACKAGE__->mk_classdata('path_part');
__PACKAGE__->mk_classdata('profile_for_edit');

sub edit : Chained('endpoint') :PathPart('edit') {
    my ( $self, $c ) = @_;
    $c->stash->{template} = $self->path_part . '/edit.tt';
    $c->set_fillform( $c->stash->{entry_obj}->as_fdat );
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
    my $v = $form->valid;

    $entry_obj->update_from_v( $v );
    $entry_obj->save();
    $c->redirect('/'. $self->path_part . '/?' . $self->path_part .'_id=' . $entry_obj->id );

}

sub add : Local {
    my ( $self, $c ) = @_;
    if( $c->req->method eq 'POST' ) {
        $c->forward('do_add');
    }
}

sub do_add : Private {
    my ( $self, $c ) = @_;
    my $form = $c->form( $self->profile_for_edit );
    if( $form->has_error ) {
        return ;
    }
    my $v = $form->valid;
    my $entry_obj = $self->entry_obj->new( %$v );
    $entry_obj->save();
    $c->redirect('/'. $self->path_part );
}

__POLOCKY__;
