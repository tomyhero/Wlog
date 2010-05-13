package Wlog::Resource;
use Polocky::Class;
use Polocky::Utils;
use IO::All;

sub footer_freearea {
    my $file = Polocky::Utils::config->resource('footer_freearea_path');
    if( $file && -e $file ){
        return io($file)->utf8->all;
    }
    else {
        return '';
    }

}


__POLOCKY__;
