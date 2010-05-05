use warnings;
use strict;
use FindBin;
use Path::Class;
use lib Path::Class::Dir->new($FindBin::Bin, '..', 'lib')->stringify;
use Wlog::CMS;
my $app = Wlog::CMS->new;
my $handler = $app->psgi_handler ;
