package Wlog::Sidebar::Freearea;
use Polocky::Class;
extends 'Wlog::Sidebar::Base';

has '+description' => (
    default => 'HTMLを自由に入力することができます。',
);
has '+title' => (
    default => 'フリーエリア',
);

has 'html_field' => (
    is => 'rw',
);

has 'profile' =>  (
    is => 'rw',
    default =>  sub {
        {
            required => [qw/name html /],
            level => {
                html => 'sidebar',
                name => 'sidebar',
            }
        };
    },
);

has 'fields' => (
    is => 'rw',
    default => sub {
        [
            {
                name => 'name',
                type => 'text', 
            },
            {
                name => 'html',
                type => 'textarea', 
            },

        ]
    }
);

has 'labels' => (
    is => 'rw',
    default => sub {
        {
            html => 'HTML',
            name => '表記名',
        }
    }
);

sub disp_html {
    my $self = shift;
    return $self->html_field;
}

__POLOCKY__;
