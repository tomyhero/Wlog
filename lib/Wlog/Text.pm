package Wlog::Text;

use warnings;
use strict;
use Text::Livedoor::Wiki;
use Text::Livedoor::Wiki::Plugin;

sub new {
    my $class = shift;
    my $block_plugins   = Text::Livedoor::Wiki::Plugin->block_plugins({
        except  => ['Text::Livedoor::Wiki::Plugin::Block::CopyAndPaste'],
        addition  => ['Wlog::Text::Block::CopyAndPaste'],

    });
    my $wiki = Text::Livedoor::Wiki->new({
        opts => { storage => '/static/wiki' } ,
        block_plugins => $block_plugins,
    });

    return $wiki; 
}

1;
