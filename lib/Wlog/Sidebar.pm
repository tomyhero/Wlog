package Wlog::Sidebar;
use Polocky::Class;
use Module::Pluggable::Object;

has 'plugins' => (
    is => 'rw',
);
has 'plugin' => (
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

sub BUILD {
    my $self = shift;
    my $finder =  Module::Pluggable::Object->new( search_path => ['Wlog::Sidebar'] ,except => ['Wlog::Sidebar::Base'] , require => 1);
    my @plugins = $finder->plugins;
    my @objs = map { $_->new( fvl => $self->fvl , category_obj => $self->category_obj ) } @plugins;
    my %hash = map { $_->name => $_ } @objs ;
    $self->plugins( \@objs );
    $self->plugin( \%hash );
}

sub get {
    my $self = shift;
    my $name = shift;
    return $self->plugin->{$name};
}

__POLOCKY__;

=head1 NAME

Wlog::Sidebar - 

=head1 SYNOPSIS

 my $sidebar = Wlog::Sidebar->new( fvl => $fvl , category_obj => $category_obj );
 my $list = $sidebar->list;
 my $freearea = $sidebar->get('Freearea', $data );
 my $recent = $sidebar->get('Recent', $data );

=cut
