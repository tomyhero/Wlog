package Wlog::Text;

use warnings;
use strict;
use base qw(Class::Singleton);
use Text::Livedoor::Wiki;
use Text::Livedoor::Wiki::Plugin;

sub _new_instance {
    my $class = shift;
    my $self  = bless { }, $class;

    my $block_plugins   = Text::Livedoor::Wiki::Plugin->block_plugins({
        except  => ['Text::Livedoor::Wiki::Plugin::Block::CopyAndPaste'],
        addition  => ['Wlog::Text::Block::CopyAndPaste'],
    });
    my $inline_plugins   = Text::Livedoor::Wiki::Plugin->inline_plugins({
        except  => ['Text::Livedoor::Wiki::Plugin::Inline::WikiPage'],
        addition  => ['Wlog::Text::Inline::WikiPage'],
    });

    my $wiki = Text::Livedoor::Wiki->new({
        opts => { storage => '/static/wiki' } ,
        block_plugins => $block_plugins,
        inline_plugins => $inline_plugins,
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
