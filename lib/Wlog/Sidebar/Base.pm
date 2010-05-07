package Wlog::Sidebar::Base;
use Polocky::Class;
use Acme::PSON qw(obj2pson);


has 'name' => (
    is => 'rw',
    default => sub {
        my $self = shift;
        my @a = split('::',ref $self );
        return $a[-1];
    }
);

has 'fields' => (
    is => 'rw',
);

has 'fvl' => (
    is => 'rw',
    isa => 'FormValidator::LazyWay',
);

has 'category_obj' => (
    is => 'rw',
    isa => 'Wlog::Data::Category',
);

has 'title' => (
    is => 'ro',
    default => 'title',
);

has 'description' => (
    is => 'ro',
    default => 'DESCRIPTION',
);

has 'fvl_result' => (
    is => 'rw',
    isa => 'FormValidator::LazyWay::Result',
);

sub check {
    my $self = shift;
    my $data = shift;
    my $result = $self->fvl->check( $data ,$self->profile ) ;
    $self->fvl_result( $result );
    return !$result->has_error;
}

sub get {
    my $self = shift;
    return $self->fvl_result->valid;
}


sub pson {
    my $self = shift;
    return obj2pson($self->fvl_result->valid);
}

__POLOCKY__;
