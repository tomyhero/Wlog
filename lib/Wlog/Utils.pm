package Wlog::Utils;
use warnings;
use strict;
use Compress::Zlib ();
use Encode ();
use Polocky::Utils;
use Apache::Htpasswd ();

sub authenticator {
    my($username, $password) = @_;
    my $file = Polocky::Utils::config->auth('htpasswd_file');
    my $htpasswd = Apache::Htpasswd->new({
            passwdFile => $file,
            ReadOnly   => 1
        });
    return $htpasswd->htCheckPassword( $username ,$password );
}

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
