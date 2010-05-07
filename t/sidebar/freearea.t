use Test::Most ;
use warnings;
use strict;
use Polocky::Util::Initializer 'Wlog::Web';
use Wlog::Sidebar::Freearea;
use FormValidator::LazyWay;
use YAML::Syck;

my $freearea = Wlog::Sidebar::Freearea->new( fvl => &fvl_obj );
is( $freearea->name , 'Freearea' );
if( $freearea->check( { html => '<font color="red">Hello</font>' }) ) {
    ok(1,'ok');
}
else {
    ok(0,'ng');
}

is_deeply( $freearea->get() , { html => '<font color="red">Hello</font>'} );

is($freearea->pson(), q|$PSON_VALUE1 = {'html' => '<font color="red">Hello</font>'};|);

sub fvl_obj {
    local $YAML::Syck::ImplicitUnicode =1;
    my %args = ();
    my $config = Wlog::Config->instance->plugin('Wlog::WAF::Plugin::FVL');
    $args{config} = YAML::Syck::LoadFile(  $config->{yaml_file} );
    return FormValidator::LazyWay->new( %args ) ;

}

done_testing();
