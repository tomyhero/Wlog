package Wlog::Sidebar::Recent;
use Polocky::Class;
extends 'Wlog::Sidebar::Base';
use Wlog::Data::Article;

has '+description' => (
    default => '更新順に記事一覧を表示します',
);
has '+title' => (
    default => '更新記事一覧',
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

    my @article_obj 
        = $category_obj->id 
        ? Wlog::Data::Article->search( { category_id => $category_obj->id } , { sort => 'updated_at' , direction => 'descend' , limit => 5 } )
        : Wlog::Data::Article->search( {} , { sort => 'updated_at' , direction => 'descend' , limit => 5 } );

    my $html = '<ul>';
    for(@article_obj) {
        $html .= '<li>' . $_->updated_at . ' <a href="' . $_->article_url . '">' . $_->name . '</a></li>';
    }
    $html .='</ul>';
    return $html;
}

__POLOCKY__;
