package Polocky::WAF::CatalystLike::Context;
use Polocky::Class;
extends 'Polocky::WAF::Context';

has stack => (is => 'ro', default => sub { [] });
has 'dispatcher' => (
    is => 'rw',
);
has state => (is =>'rw');
has 'action' => (
    is => 'rw',
);
has 'namespace' => (
    is => 'rw',
);
has 'components' => (
    is => 'rw',
);

after 'PREPARE' => sub {
    my $c = shift;
    $c->prepare_action();
};

sub DISPATCH {
    my $c = shift;
    my $dispatch = $c->dispatcher->dispatch( $c );
}

sub prepare_action {
    my $c = shift;
    $c->dispatcher->prepare_action( $c );
}


sub depth { scalar @{ shift->stack || [] }; }
sub forward {
    my $c = shift;
    no warnings 'recursion';
    $c->dispatcher->forward( $c, @_ )
}
sub get_action { my $c = shift; $c->dispatcher->get_action(@_) }
sub get_actions { my $c = shift; $c->dispatcher->get_actions( $c, @_ ) }
our $RECURSION = 1000;
sub execute {
    my ( $c, $class, $code ) = @_;
    $class = $c->component($class) || $class;
    $c->state(0);

    if ( $c->depth >= $RECURSION ) {
        my $action = $code->reverse();
        $action = "/$action" unless $action =~ /->/;
        my $error = qq/Deep recursion detected calling "${action}"/;
        #$c->log->error($error);
        #$c->error($error);
        $c->state(0);
        return $c->state;
    }

    push( @{ $c->stack }, $code );

    no warnings 'recursion';
    eval { $c->state( $code->execute( $class, $c, @{ $c->req->args } ) || 0 ) };

    my $last = pop( @{ $c->stack } );

    if ( my $error = $@ ) {
        if ( blessed($error) and $error->isa('Polocky::Exception::Detach') ) {
            $error->rethrow if $c->depth > 1;
        }
        else {
            # TODO
            $c->error($error);
            $c->state(0);
            die $error;
        }
    }
    return $c->state;
}

sub component {
    my ( $c, $name) = @_;
    my $comps = $c->components;
    return $comps->{ $name };
}

sub detach { my $c = shift; $c->dispatcher->detach( $c, @_ ) }


sub view {
    my ( $c, $name) = @_;
     my $pkg =  Polocky::Utils::app_class . '::' .  Polocky::Utils::app_sub_class . '::View';
    return $c->component( $pkg );
}

sub reset {
    my $c = shift;
    $c->state(0);
    $c->error(0);
}


__POLOCKY__ ;
