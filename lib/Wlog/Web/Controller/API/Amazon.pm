package Wlog::Web::Controller::API::Amazon;
use Polocky::Class;
use URI::Amazon::APA;
use LWP::UserAgent;
use XML::Simple;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub item : LocalRegex('([a_zA-Z0-9]+)') {
    my ( $self, $c ) = @_;
    my $config = $c->config->api('amazon');
    my $asin = $c->req->captures->[0];
    my $u = URI::Amazon::APA->new( $config->{endpont} );
    $u->query_form(
        Service     => 'AWSECommerceService',
        Operation   => 'ItemLookup',
        ResponseGroup   => 'Small,Images',
        IdType => 'ASIN',
        ItemId => $asin,
        AssociateTag => 'laz01-22',
        );
    
    $u->sign(
        key    => $config->{key},
        secret => $config->{secret},
        );

    my $ua = LWP::UserAgent->new;
    my $r  = $ua->get($u);
    if ( $r->is_success ) {
        my $data = XMLin( $r->content );
        my $item = {
            asin => $asin,
            url => $data->{Items}{Item}{DetailPageURL} || '',
            image => $data->{Items}{Item}{MediumImage}{URL} || '',
            title => $data->{Items}{Item}{ItemAttributes}{Title} || '',
        };

        $c->view()->render($c,'JSON', { item => $item  , status => 1 }  );
    }
    else {
        $c->view()->render($c,'JSON', {  status => 0  }  );
    }
}

__POLOCKY__;
