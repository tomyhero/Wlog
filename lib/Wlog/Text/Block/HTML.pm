package Wlog::Text::Block::HTML;

use strict;
use warnings;
use base qw(Text::Livedoor::Wiki::Plugin::Block);
our $VERSION = '0.01';

__PACKAGE__->trigger({ 
     start=> '^__HTML__$' , 
     end  => '^__HTML__$' , 
     escape => 1 });

sub check {
    my $class        = shift;
    my $line        = shift;
    my $args        = shift;
    my $on_next     = $args->{on_next};
    my $id          = $args->{id};
    my $scratchpad  = $Text::Livedoor::Wiki::scratchpad;
    my $row;
    my $option_str;
    my $processing = $scratchpad->{block}{$id}{processing};

    # header
    if (( ( $row, $option_str ) = $line =~ /^__HTML__$/) 
     && !$processing  && !$on_next ){
        my $res = { id => $id };
        $scratchpad->{block}{$id}{processing} = 1;
        return $res;
    }
    # end box
    elsif( $line =~ /^__HTML__$/ && $processing 
     && !$on_next ) {
        $scratchpad->{block}{$id}{processing} = 0;
        return { line => '' } ;
    }
    # finalize
    elsif( $on_next && !$processing ) {
        return ;
    }
    # processing
    elsif( $processing ) {
        return { line => $line  };
    }
    # not much
    return;
}
sub get {
    my $class = shift;
    my $block = shift;
    my $inline = shift;
    my $items = shift;
    my $meta = shift @{$items};
    my $id         = $meta->{id};
    my $data = '';
    $data .= $_->{line} . "\n" for @$items;
    $data =~ s/\n$//;
    return $data;
}
