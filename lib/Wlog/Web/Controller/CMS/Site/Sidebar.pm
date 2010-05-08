package Wlog::Web::Controller::CMS::Site::Sidebar;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };


sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my $category_obj = Wlog::Data::Category->new( id => 0 );
    my $sidebar = Wlog::Sidebar->new( fvl => $c->_fvl , category_obj => $category_obj );
    $c->stash->{sidebar} = $sidebar;
    my @sidebar_objs = $self->entry_obj->search( { category_id => $category_obj->id } , { sort => 'sort' , direction => 'descend' } );
    $c->stash->{sidebar_objs} = \@sidebar_objs;
}

__POLOCKY__;
