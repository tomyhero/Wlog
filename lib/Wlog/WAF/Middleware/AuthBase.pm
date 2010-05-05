package Wlog::WAF::Middleware::AuthBase;
use warnings;
use strict;
use MIME::Base64;
use base qw(Plack::Middleware::Auth::Basic);

sub call {
    my($self, $env) = @_;

    my $path_info = $env->{PATH_INFO} ;

    return $self->app->($env) unless $path_info =~ /^\/cms/;

    my $auth = $env->{HTTP_AUTHORIZATION}
        or return $self->unauthorized;

    if ($auth =~ /^Basic (.*)$/) {
        my($user, $pass) = split /:/, (MIME::Base64::decode($1) || ":");
        $pass = '' unless defined $pass;
        if ($self->authenticator->($user, $pass)) {
            $env->{REMOTE_USER} = $user;
            return $self->app->($env);
        }
    }

    return $self->unauthorized;
}


1;
