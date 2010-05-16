package Wlog::Text;

use warnings;
use strict;
use base qw(Class::Singleton);
use Text::Livedoor::Wiki;
use Text::Livedoor::Wiki::Plugin;

sub _new_instance {
    my $class = shift;
    my $self  = bless { }, $class;

    # XXX
    no warnings 'redefine';
    *Text::Livedoor::Wiki::Block::footer_section = sub {
        my $self = shift;
        my $res = '';
        my $footnotes = $Text::Livedoor::Wiki::scratchpad->{footnotes};

        if( $footnotes ) {
            $res =qq|<div class="footer-footnote">\n<hr />\n<ul class="list-1">\n|;
            my $cnt = 1;
            for ( @$footnotes ) {
                $res .=qq|<li><a href="#footnote$cnt" name="footer-footnote$cnt">*$cnt </a> : $_</li>\n|;
                $cnt++;
            }
            $res .="<ul>\n</div>\n";
        }

        my $amazons = $Text::Livedoor::Wiki::scratchpad->{amazons};

        if( $amazons ) {
            $res .="<script>";
            for(@$amazons){
                $res .= sprintf( "WlogAPI.amazon_lookup('%s','%s');", $_->{uid},$_->{asin} );
            }
            $res .="</script>";
        }

        return $res;
    };


    my $block_plugins   = Text::Livedoor::Wiki::Plugin->block_plugins({
        except  => ['Text::Livedoor::Wiki::Plugin::Block::CopyAndPaste'],
        addition  => ['Wlog::Text::Block::CopyAndPaste'],
    });
    my $inline_plugins   = Text::Livedoor::Wiki::Plugin->inline_plugins({
        except  => ['Text::Livedoor::Wiki::Plugin::Inline::WikiPage'],
        addition  => ['Wlog::Text::Inline::WikiPage'],
    });

    my $function_plugins   = Text::Livedoor::Wiki::Plugin->function_plugins({
        addition  => ['Wlog::Text::Function::Amazon'],
    });

    my $wiki = Text::Livedoor::Wiki->new({
        opts => { storage => '/static/wiki' } ,
        block_plugins => $block_plugins,
        inline_plugins => $inline_plugins,
        function_plugins => $function_plugins,
    });
    $self->{wiki} = $wiki;

    return $self;
}

sub parse {
    my $self = shift;
    my $text = shift;
    my $opts = shift || {};
    $self->{wiki}->parse( $text ,$opts);;
}

1;
