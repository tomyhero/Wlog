package Wlog::Web::Controller::CMS;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub auto : Private {
    my ( $self, $c ) = @_;


    1;
}
__POLOCKY__;
