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

__POLOCKY__;
