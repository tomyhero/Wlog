package Wlog::Sidebar::TagCloud;
use Polocky::Class;
extends 'Wlog::Sidebar::Base';
use Wlog::Data::Tag;
use Wlog::Data::CategoryTag;
use HTML::TagCloud;

has '+description' => (
    default => 'タグクラウドを表示します',
);
has '+title' => (
    default => 'タグ',
);

has 'limit_field' => (
    is => 'rw',
);

has 'profile' =>  (
    is => 'rw',
    default =>  sub {
        {
            required => [qw/name limit/],
            level => {
                name => 'sidebar',
                limit => 'sidebar',
            }
        };
    },
);

has 'fields' => (
    is => 'rw',
    default => sub {
        [
            {
                name => 'limit',
                type => 'text', 
            },
            {
                name => 'name',
                type => 'text', 
            },
        ]
    }
);

has 'labels' => (
    is => 'rw',
    default => sub {
        {
            name => '表記名',
            limit => '表示件数',
        }
    }
);

sub disp_html {
    my $self = shift;
    my $category_obj = $self->category_obj;

    my @tag_objs = ();
    if( $category_obj ) {
        my @category_tag_objs = Wlog::Data::CategoryTag->search( { category_id => $category_obj->id } , { sort => 'per_use', direction => 'descend', limit => $self->limit_field } );
        for(@category_tag_objs) {
            push @tag_objs , $_->tag_obj;
        }
    }
    else {
        @tag_objs = Wlog::Data::Tag->search( {} , { sort => 'per_use', direction => 'descend', limit => $self->limit_field } );
    }
    my $html = '';

    my $cloud = HTML::TagCloud->new();
    for(@tag_objs){
        $cloud->add( $_->name, $_->url , $_->per_use );
    }

    return $cloud->html_and_css();
}

__POLOCKY__;
