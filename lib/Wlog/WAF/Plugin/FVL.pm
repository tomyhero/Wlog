package Wlog::WAF::Plugin::FVL;

use strict;
use warnings;
use Polocky::Role;
use FormValidator::LazyWay;
use FormValidator::LazyWay::Result;
use YAML::Syck;

has '_dfv' => ( is => 'rw');

before 'SETUP' => sub  {
    my $c =  shift;
    local $YAML::Syck::ImplicitUnicode =1;
    my %args = ();
    my $config = $c->config->plugin('Wlog::WAF::Plugin::FVL');
    $args{config} = YAML::Syck::LoadFile(  $config->{yaml_file} );
    $args{result_class} = $config->{result_class} if  $config->{result_class};
    my $dfv = FormValidator::LazyWay->new( %args ) ;
    $c->_dfv( $dfv );

    1;
};

sub form {
    my $c = shift;
    my $profile = shift;
    my $form = $c->_dfv->check( $c->req->parameters->as_hashref_mixed , $profile );
    $c->stash->{form} = $form;
    $c->stash->{v}    = $form->valid();
    return $form;
}

sub create_form { 
    my $c = shift;
    my $form = $c->_dfv->result_class->new({}) ;
    $c->stash->{form} = $form;
}


1;
