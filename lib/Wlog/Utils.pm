package Wlog::Utils;
use warnings;
use strict;
use Compress::Zlib ();
use Encode ();

sub compress { 
    my $text = shift;
    $text = Encode::encode( 'utf8',$text );
    Compress::Zlib::memGzip( $text ); 
}

sub uncompress { 
    my $ziped = shift;
    my $text = Compress::Zlib::memGunzip($ziped); 
    $text = Encode::decode( 'utf8',$text );
}
 

1;
