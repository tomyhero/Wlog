package Wlog::Data::Plugin::Base;
use strict;
use warnings;
use base qw(Class::Data::Inheritable);
__PACKAGE__->mk_classdata('methods');
__PACKAGE__->methods([]);

1;

