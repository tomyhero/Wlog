package Wlog::FVL::Fix;
use warnings;
use strict;


sub tags_array {
    my $tags = shift;
    my @tags = split(/\s/ , $tags); 
    return \@tags;
}


1;
