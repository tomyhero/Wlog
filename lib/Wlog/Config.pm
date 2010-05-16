package Wlog::Config;
use base qw(Polocky::Config);

sub database {
    my $self = shift;
    my $section = shift;
    return $self->_get( 'database' );
}

sub site {
    my $self = shift;
    my $section = shift;
    return $self->_get( 'site' , $section );
}

sub auth {
    my $self = shift;
    my $section = shift;
    return $self->_get( 'auth' , $section );
}

sub resource {
    my $self = shift;
    my $section = shift;
    return $self->_get( 'resource' , $section );
}
sub api {
    my $self = shift;
    my $section = shift;
    return $self->_get( 'api' , $section );
}

1;


