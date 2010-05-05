package Wlog::Config;
use base qw(Polocky::Config);

sub database {
    my $self = shift;
    my $section = shift;
    return $self->_get( 'database' );
}

1;

