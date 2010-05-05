package Wlog::WAF::Plugin::FillInForm;
use strict;
use warnings;
use Polocky::Role;
use HTML::FillInForm::Lite;

before 'FINALIZE' => sub {
    my $c = shift;
    if ( $c->stash->{form} && $c->stash->{form}->has_error ) {
        my $v =  $c->stash->{form}->valid;
        $c->fillform( $v ) ;
    }
    else {
        $c->fillform( $c->stash->{__F_D_A_T__} );
    }
};

sub set_fillform {
    my $c    = shift;
    my $fdat = shift;
    $c->stash->{__F_D_A_T__} = $fdat;
}

sub fillform {
    my $c    = shift;
    my $fdat = shift || $c->req->parameters->as_hashref_mixed || {};
    my $additional_params = shift || {};
    %$fdat = ( %$fdat , %$additional_params );

    return 1 unless ($c->res->{body});
    $c->res->{body} = 
        HTML::FillInForm::Lite->new->fill(
            \$c->res->{body},
            $fdat,
        ) || '' ;
}

1;
