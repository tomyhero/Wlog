package Wlog::Web::Controller::CMS::Category::Sidebar;
use Polocky::Class;
use Wlog::DateTime;
use Wlog::Sidebar;
use Wlog::Data::Sidebar;
use Storable qw(dclone);

__PACKAGE__->path_part( 'cms/category/sidebar' );
__PACKAGE__->entry_obj( 'Wlog::Data::Sidebar' );

BEGIN { extends 'Wlog::WAF::CatalystLike::Controller::CMS' };

sub endpoint :Chained('/cms/category/endpoint_category_or_default') :PathPart('sidebar') :CaptureArgs(1) {
    my ($self, $c, $id ) = @_;
    my $entry_obj = $self->entry_obj->lookup( $id ) or $c->detach('/error');
    my $category_obj = $c->stash->{category_obj};
    $c->detach('/error') if $entry_obj->category_id != $category_obj->id ;
    $c->stash->{entry_obj} = $entry_obj;
    return 1;
}

sub index : Chained('/cms/category/endpoint_category_or_default') :PathPart('sidebar') {
    my ( $self, $c ) = @_;
    my $category_obj = $c->stash->{category_obj};
    my $sidebar = Wlog::Sidebar->new( fvl => $c->_fvl , category_obj => $category_obj );
    $c->stash->{sidebar} = $sidebar;

    my @sidebar_objs = $self->entry_obj->search( { category_id => $category_obj->id } , { sort => 'sort' , direction => 'descend' } );
    $c->stash->{sidebar_objs} = \@sidebar_objs;

}
sub add : Chained('/cms/category/endpoint_category_or_default') :PathPart('sidebar/add') {
    my ( $self, $c ) = @_;
    my $category_obj = $c->stash->{category_obj};

    my $form = $c->form( { required => qw/sidebar_plugin/ } );
    if( $form->has_error ) {
        $c->detach('/error');
    }
    my $v = $form->valid;
    ### XXX 
    my $sidebar = Wlog::Sidebar->new( fvl => $c->_fvl , category_obj => $category_obj );
    my $sidebar_plugin = $sidebar->get( $v->{sidebar_plugin} ) or $c->detach('/error');
    $c->stash->{sidebar_plugin} = $sidebar_plugin;

    if( $c->req->method eq 'POST' ) {
        $c->detach('do_add');
    }

}

sub do_add : Private {
    my ( $self, $c ) = @_;
    my $category_obj = $c->stash->{category_obj};
    my $sidebar_plugin = $c->stash->{sidebar_plugin} ;

    unless( $sidebar_plugin->check( $c->req->parameters->as_hashref_mixed ) ) {
        my $form = $sidebar_plugin->fvl_result;
        $c->stash->{form} = $form;
        $c->stash->{v}    = $form->valid();
        return;
    }

    # XXX sort!
    my $sort = 0;
    if ( $c->req->param('sort') && $c->req->param('sort') =~ /^\d+$/ ){
        $sort =  $c->req->param('sort');        
    }

    my $pson = $sidebar_plugin->pson;
    my $sidebar_obj = $self->entry_obj->new( sidebar_plugin => $sidebar_plugin->name , 'sort' => $sort , pson => $pson , category_id => $category_obj->id ); 
    $sidebar_obj->save;

    $c->redirect( $c->req->uri_build([ 'cms','category',$category_obj->id,'sidebar' ]) );

}

__POLOCKY__;
