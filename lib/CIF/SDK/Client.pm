package CIF::SDK::Client;

use strict;
use warnings;

use Mouse;
use HTTP::Tiny;
use CIF::SDK;
use JSON qw(encode_json decode_json);
use Time::HiRes qw(tv_interval gettimeofday);

use constant {
    PORT_DEFAULT    => 443,
    HOST_DEFAULT    => 'https://localhost',
    HEADERS_DEFAULT => {
        'Accept'    => 'application/json',
    },
    AGENT_DEFAULT   => 'cif-sdk-perl/'.$CIF::SDK::VERSION,
    TIMEOUT_DEFAULT => 300,
};

has 'host' => (
    is      => 'ro',
    isa     => 'Str',
    reader  => 'get_host',
    default => HOST_DEFAULT(),
);

has 'token' => (
    is      => 'ro',
    isa     => 'Str',
    reader  => 'get_token',
);

has 'port' => (
    is      => 'ro',
    isa     => 'Int',
    reader  => 'get_port',
    default => PORT_DEFAULT(),
);

has 'proxy' => (
    is      => 'ro',
    isa     => 'Str',
    reader  => 'get_proxy',
);

has 'timeout'   => (
    is      => 'ro',
    isa     => 'Int',
    reader  => 'get_timeout',
    default => TIMEOUT_DEFAULT(),
);

has 'headers' => (
    is      => 'ro',
    isa     => 'HashRef',
    reader  => 'get_headers',
    default => sub { HEADERS_DEFAULT() },
);

has 'verify_ssl' => (
    is      => 'ro',
    isa     => 'Bool',
    reader  => 'get_verify_ssl',
    default => 1,
);

has 'handle' => (
    is      => 'ro',
    isa     => 'HTTP::Tiny',
    reader  => 'get_handle',
    builder => '_build_handle',
);

# helpers

sub _build_handle {
    my $self = shift;
    
    return HTTP::Tiny->new(
        agent   => AGENT_DEFAULT(),
        default_headers => $self->get_headers(),
        timeout         => $self->get_timeout(),
        verify_ssl      => $self->get_verify_ssl(),
        proxy           => $self->get_proxy(),
    );   
}

sub request {
    my $self = shift;
    my $args = shift;
    
    my $uri = $self->get_host().':'.$self->get_port();
    
    $uri = $uri . '?token='.$self->get_token();
    $uri .= '&confidence='.$args->{'confidence'} if($args->{'confidence'});
    $uri .= '&limit='.$args->{'limit'} if($args->{'limit'});
    $uri .= '&group='.$args->{'group'} if($args->{'group'});
}

# main

sub search {
    my $self = shift;
    my $args = shift;
    
    my $uri = $self->get_host().':'.$self->get_port().'/'.$args->{'observable'}.'?token='.$self->get_token();
    $uri .= '&confidence='.$args->{'confidence'} if($args->{'confidence'});
    $uri .= '&limit='.$args->{'limit'} if($args->{'limit'});
    $uri .= '&group='.$args->{'group'} if($args->{'group'});
    
    my $resp = $self->get_handle()->get($uri);
    
    return 'request failed('.$resp->{'status'}.'): '.$resp->{'reason'} unless($resp->{'status'} eq '200');
    
    return (undef,decode_json($resp->{'content'}));
    
}

sub submit {
    my $self = shift;
    my $args = shift;
    
    $args = [$args] if(ref($args) eq 'HASH');
    
    $args = encode_json($args);
    
    my $uri = $self->get_host().':'.$self->get_port().'/?token='.$self->get_token();
    my $resp = $self->get_handle->post($uri,{ content => $args });

    warn ::Dumper($resp);
    my $content = decode_json($resp->{'content'});

    return $content->{'message'} if($resp->{'status'} > 399);
    return (undef, $content, $resp);
}

sub ping {
    my $self = shift;
    
    my $t0 = [gettimeofday()];
    
    my $uri = $self->get_host.':'.$self->get_port().'/_ping?token='.$self->get_token();
    my $resp = $self->get_handle()->get($uri);
    
    return $resp->{'reason'} unless($resp->{'status'}) eq '200';
    my $t1 = decode_json($resp->{'content'})->{'timestamp'};
    return (undef,tv_interval($t0,[gettimeofday]),$t1);
}

1;
