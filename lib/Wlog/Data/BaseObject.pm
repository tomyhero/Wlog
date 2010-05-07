package Wlog::Data::BaseObject;

use strict;
use warnings;
use base qw( Data::ObjectDriver::BaseObject Class::Data::Inheritable);
use Sub::Install;
use Data::ObjectDriver::SQL;
use Wlog::DateTime;

__PACKAGE__->add_trigger(
    pre_search => sub {
        my ( $class, $terms, $args ) = @_;
        if ( $args && ( my $pager = delete $args->{pager} ) ) {
            $pager->total_entries($class->count( $terms ));
            $args->{limit}  = $pager->entries_per_page;
            $args->{offset} = $pager->skipped;
        }
    },
);
__PACKAGE__->add_trigger(
    pre_insert => sub {
        my ( $obj, $orig ) = @_;
        my $now = Wlog::DateTime->sql_now ;
        if ( $obj->has_column('created_at') && !$obj->created_at ) {
            $obj->created_at( $now );
            $orig->created_at( $now );
        }

        if ( $obj->has_column('updated_at') ) {
            $obj->updated_at( $now );
            $orig->updated_at( $now );
        }

        my $default = $obj->default_values;
        for my $key(keys %{$default}) {
            unless (defined $obj->$key()) {
                $obj->$key( $default->{$key} );
                $orig->$key( $default->{$key} );
            }
        }
    },
);
__PACKAGE__->add_trigger(
    pre_update => sub {
        my ( $obj, $orig ) = @_;
        if ( $obj->has_column('updated_at') ) {
            my $now = Wlog::DateTime->sql_now ;
            $obj->updated_at( $now );
            $orig->updated_at( $now );
        }
    },

);

sub default_values { +{}; }

sub install_plugins {
    my $class = shift;
    my $plugins = shift;
    for my $plugin ( @$plugins ) {
        $plugin = 'Wlog::Data::Plugin::' . $plugin;
        $plugin->require or die $@;
        for my $method ( @{$plugin->methods} ) {
            Sub::Install::install_sub({
                code => $method,
                from => $plugin,
                into => $class
            });
        }
    }
}

sub setup_alias {
    my $class = shift;
    my $map   = shift;

    for my $alias ( keys %$map ) {
        my $method_name  = $map->{$alias};
        Sub::Install::install_sub({
            code => sub { 
                my $self = shift;
                my $value = shift;
                if( defined $value ) {
                    $self->$method_name( $value ) ;
                }
                else {
                    $self->$method_name ;
                }
            } ,
            as   => $alias,
            into => $class
        });
    }
}

sub single {
    my ( $self, $terms, $options ) = @_;
    my $res = $self->search( $terms, $options );
    return $res->next;
}

sub as_fdat {
    my $self = shift;
    my $column_names  = shift || $self->column_names;
    my %fdat = map { $_ => $self->$_() } @{ $column_names };
    \%fdat;
}


sub count {
    my ( $self, $terms ) = @_;
    $terms ||= {};
    my $stmt = Data::ObjectDriver::SQL->new;
    $stmt->add_select('COUNT(*)');
    $stmt->from( [ $self->driver->table_for($self) ] );
    if ( ref($terms) eq 'ARRAY' ) {
        $stmt->add_complex_where($terms);
    }
    else {
        for my $col ( keys %$terms ) {
            $stmt->add_where( $col => $terms->{$col} );
        }
    }
    $self->driver->select_one( $stmt->as_sql, $stmt->{bind} );
}

sub update_from_v {
    my( $self, $v ) = @_;
    for my $col ( keys %$v ) {
        $self->$col( $v->{$col} );
    }
    1;
}

sub single_or_create {
    my ( $class ,$data ) = @_;
    my $obj = $class->single( $data );
    unless( $obj ) {
        $obj = $class->new( %$data );
        $obj->save;
    }
    return $obj;
}
1;
