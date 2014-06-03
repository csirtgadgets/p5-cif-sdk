package CIF::SDK::Logger;

use strict;
use warnings FATAL => 'all';

use Mouse;
use Log::Log4perl;
use Log::Log4perl::Level;

use constant LAYOUT_DEFAULT => "[%d{yyyy-MM-dd'T'HH:mm:ss,SSS}Z][%p]: %m%n";
use constant LAYOUT_DEBUG   => "[%d{yyyy-MM-dd'T'HH:mm:ss,SSS}Z][%p][%C:%L]: %m%n";
use constant LAYOUT_TRACE   => "[%d{yyyy-MM-dd'T'HH:mm:ss,SSS}Z][%p][%F:%L]: %m%n";
use constant APPENDER_DEFAULT   => 'Log::Log4perl::Appender::ScreenColoredLevels';

has 'level' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'ERROR',
    reader  => 'get_level',
);

has 'layout'    => (
    is          => 'ro',
    isa         => 'Str',
    reader      => 'get_layout',
    builder     => '_build_layout',
);

has 'category'  => (
    is      => 'ro',
    isa     => 'Str',
    reader  => 'get_category',
    default => 'CIF.Logger',
);

has 'name'  => (
    is      => 'ro',
    isa     => 'Str',
    default => 'libcif',
    reader  => 'get_name',
);

has 'logger' => (
    is          => 'ro',
    isa         => 'Log::Log4perl::Logger',
    builder     => '_build_logger',
    required    => 1,
    reader      => 'get_logger',
);

sub _build_layout {
    my $self = shift;
    
    return LAYOUT_DEBUG() if($self->get_level() eq 'DEBUG');
    return LAYOUT_TRACE() if($self->get_level() eq 'TRACE');
    return LAYOUT_DEFAULT()
}

sub _build_logger {
    my $self = shift;

    my $app = Log::Log4perl::Appender->new(
        APPENDER_DEFAULT(),
        mode        => 'append',
        name        => $self->get_name(),
        category    => $self->get_category()
    );
    $app->layout(
        Log::Log4perl::Layout::PatternLayout->new($self->get_layout())
    );
    my $rootLogger = Log::Log4perl->get_logger($self->get_category());
    $rootLogger->level($self->get_level());
    $rootLogger->add_appender($app);
    return $rootLogger;
}

__PACKAGE__->meta()->make_immutable();

1;