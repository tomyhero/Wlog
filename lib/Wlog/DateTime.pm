package Wlog::DateTime;

use strict;
use warnings;
use base qw(DateTime);
use DateTime::Format::MySQL;
use DateTime::Format::Strptime;
use DateTime::TimeZone;

our $DEFAULT_TIMEZONE = DateTime::TimeZone->new(name => 'local');
sub parse {
    my($class, $format, $date) = @_;

    my $module;
    if (ref $format) {
        $module = $format;
    } else {
        $module = "DateTime::Format::$format";
        $module->require or die $@;
    }

    my $dt = $module->parse_datetime($date) or return;

    # If parsed datetime is floating, don't set timezone here. It should be "fixed" in caller plugins
    unless ($dt->time_zone->is_floating) {
        $dt->set_time_zone($DEFAULT_TIMEZONE || 'local' );
    }

    bless $dt, $class;
}

sub sql_now {
    my $class = shift;
    my $self = $class->now(time_zone => $DEFAULT_TIMEZONE );
    $self->strftime('%Y-%m-%d %H:%M:%S');
}

sub yesterday {
    my($class) = @_;
    my $dt = $class->SUPER::now();
    return $dt->clone->subtract( days => 1 );
}

1;
