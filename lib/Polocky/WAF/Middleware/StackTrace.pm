package Polocky::WAF::Middleware::StackTrace;
use strict;
use warnings;
use parent qw/Plack::Middleware/;
use Devel::StackTrace;
use Devel::StackTrace::AsHTML;
use Try::Tiny;
use Plack::Util::Accessor qw( force no_print_errors );
use Data::Dumper;

our $StackTraceClass = "Devel::StackTrace";

# Optional since it needs PadWalker
if ($ENV{PLACK_STACKTRACE_LEXICALS} && try { require Devel::StackTrace::WithLexicals; 1 }) {
    $StackTraceClass = "Devel::StackTrace::WithLexicals";
}

sub call {
    my($self, $env) = @_;

    my $trace;
    local $SIG{__DIE__} = sub {
        $trace = $StackTraceClass->new(
            ignore_package => [
            qw/
                Polocky::WAF::CatalystLike::Action 
                Polocky::WAF::CatalystLike::Dispatcher
                Polocky::WAF::CatalystLike::Engine
                Polocky::WAF::Request
                Polocky::WAF::Engine
                PlackX::Engine
            /
            ],
            ignore_class => [
            qw/
            /
            ],
        );
                #Polocky::WAF::CatalystLike::Context
        die @_;
    };

    my $caught;
    my $res = try { $self->app->($env) } catch { $caught = $_ };

    if ($trace && ($caught || ($self->force && ref $res eq 'ARRAY' && $res->[0] == 500)) ) {
        my $text = trace_as_string($trace);
        $env->{'psgi.errors'}->print($text) unless $self->no_print_errors;
        if (($env->{HTTP_ACCEPT} || '*/*') =~ /html/) {
            $res = [500, ['Content-Type' => 'text/html; charset=utf-8'], [ utf8_safe($trace->as_html) ]];
        } else {
            $res = [500, ['Content-Type' => 'text/plain; charset=utf-8'], [ utf8_safe($text) ]];
        }
    }

    # break $trace here since $SIG{__DIE__} holds the ref to it, and
    # $trace has refs to Standalone.pm's args ($conn etc.) and
    # prevents garbage collection to be happening.
    undef $trace;

    return $res;
}

sub trace_as_string {
    my $trace = shift;

    my $st = '';
    my $first = 1;
    foreach my $f ( $trace->frames() ) {
        $st .= "\t" unless $first;
        $st .= $f->as_string($first) . "\n";
        $first = 0;
    }

    return $st;

}

sub utf8_safe {
    my $str = shift;

    # NOTE: I know messing with utf8:: in the code is WRONG, but
    # because we're running someone else's code that we can't
    # guarnatee which encoding an exception is encoded, there's no
    # better way than doing this. The latest Devel::StackTrace::AsHTML
    # (0.08 or later) encodes high-bit chars as HTML entities, so this
    # path won't be executed.
    if (utf8::is_utf8($str)) {
        utf8::encode($str);
    }

    $str;
}

1;

