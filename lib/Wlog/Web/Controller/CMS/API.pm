package Wlog::Web::Controller::CMS::API;
use Polocky::Class;
use Wlog::Text;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub preview : Local {
    my ($self, $c) = @_;
    my $form = $c->form({ required => [qw/body/]});
    if( $form->has_error ) {
        $c->view()->render($c,'JSON', { status => 0 }  );
        return;
    }
    my $v = $form->valid;
    my $article = Wlog::Text->instance()->parse( $v->{body} ) ; 
    $c->view()->render($c,'JSON', { article => $article , status => 1 }  );
}

__POLOCKY__;
