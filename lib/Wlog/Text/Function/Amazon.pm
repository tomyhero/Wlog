package Wlog::Text::Function::Amazon;
use warnings;
use strict;
use base qw/Text::Livedoor::Wiki::Plugin::Function/;
__PACKAGE__->function_name('amazon');

sub prepare_args {
    my $class= shift;
    my $args = shift;
    die 'no arg' unless scalar @$args ;
    my $asin = $args->[0];
    die 'invalid format' unless $asin =~ /^[a-zA-Z0-9-_]+$/;
    return { asin => $asin };
}
sub process {
    my ( $class, $inline, $data ) = @_;
    my $asin = $data->{args}{asin};
    my $uid = $class->uid;
    $Text::Livedoor::Wiki::scratchpad->{amazons} = [] unless $Text::Livedoor::Wiki::scratchpad->{amazons};

    push @{$Text::Livedoor::Wiki::scratchpad->{amazons}}, { uid => $uid , asin => $asin } ;
    return qq|<div id="$uid"></div>|;

}

1;

