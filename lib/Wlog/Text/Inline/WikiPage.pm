package Wlog::Text::Inline::WikiPage;
use strict;
use warnings;
use base qw(Text::Livedoor::Wiki::Plugin::Inline::WikiPage);
use Text::Livedoor::Wiki::Utils;
use URI::Escape;

sub process {
    my ( $class , $inline , $label , $pagename  ) = @_;
    if( $label ) {
        $label =~ s/>$//;
    }
    else {
        $label = $pagename;
    }
    $label = Text::Livedoor::Wiki::Utils::escape( $label );
    if ( $pagename =~ /^(http|https|ftp):\/\// ) {
        my $url = Text::Livedoor::Wiki::Utils::escape($pagename);
        return qq|<a href="$url" class="outlink">$label</a>|;
    }
    else {
        $pagename = URI::Escape::uri_escape_utf8( $pagename );
        my $base_url = $class->opts->{inline_wikipage_base_url} || '/';
        my $category_obj = $class->opts->{category_obj} ;
        if($category_obj){
            my $key = $category_obj->key;
            return qq|<a href="$base_url$key/$pagename">$label</a>|;
        }
        else {
            return qq|<a href="$base_url$pagename">$label</a>|;
        }
    }
}

1;
