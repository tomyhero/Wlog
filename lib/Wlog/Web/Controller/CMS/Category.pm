package Wlog::Web::Controller::CMS::Category;
use Polocky::Class;
use Wlog::Data::Category;

__PACKAGE__->path_part( 'cms/category' );
__PACKAGE__->entry_obj( 'Wlog::Data::Category' );
__PACKAGE__->profile_for_edit(
        +{
            required => [qw/category_key category_name sort/]
        }
        );


BEGIN { extends 'Wlog::WAF::CatalystLike::Controller::CMS' };

sub endpoint :Chained('/') :PathPart('cms/category') :CaptureArgs(1) {
    my ($self, $c, $id ) = @_;
    my $entry_obj = $self->entry_obj->lookup( $id ) or $c->detach('/error');
    $c->stash->{entry_obj} = $entry_obj;
    return 1;
}

sub endpoint_category :Chained('/') :PathPart('cms/category') :CaptureArgs(1) {
    my ($self, $c, $id ) = @_;
    my $entry_obj = $self->entry_obj->lookup( $id ) or $c->detach('/error');
    $c->stash->{category_obj} = $entry_obj;
    return 1;
}

sub endpoint_category_or_default  :Chained('/') :PathPart('cms/category') :CaptureArgs(1) {
    my ($self, $c, $id ) = @_;
    if($id == 0 ) {
        my $entry_obj = $self->entry_obj->new( id => 0 ,name => 'なし' ) ;
        $c->stash->{category_obj} = $entry_obj;
    }
    else {
        my $entry_obj = $self->entry_obj->lookup( $id ) or $c->detach('/error');
        $c->stash->{category_obj} = $entry_obj;
    } 
    return 1;
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my @category_objs = Wlog::Data::Category->search({},{ sort => 'sort' , direction => 'descend' } );
    $c->stash->{category_objs} = \@category_objs;
}

__POLOCKY__;
