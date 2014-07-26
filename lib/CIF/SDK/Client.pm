package CIF::SDK::Client;

use strict;
use warnings FATAL => 'all';

use Mouse;
use HTTP::Tiny;
use CIF::SDK qw/init_logging $Logger/;
use JSON::XS qw(encode_json decode_json);
use Time::HiRes qw(tv_interval gettimeofday);

=head1 NAME

CIF::SDK::Client - The SDK Client

=head1 SYNOPSIS

the SDK is a thin development kit for developing CIF applications

    use 5.011;
    use CIF::SDK::Client;
    use feature 'say';

    my $context = CIF::SDK::Client->new({
        token       => '1234',
        remote      => 'https://localhost/api',
        timeout     => 10,
        verify_ssl  => 0,
    });
    
    my ($err,$ret) = $cli->ping();
    say 'roundtrip: '.$ret.' ms';
    
    ($err,$ret) = $cli->search({
        query       => $query,
        confidence  => $confidence,
        limit       => $limit,
    });
    
    my $formatter = CIF::SDK::FormatFactory->new_plugin({ format => '{ json | csv | snort | bro }' });
    my $text = $formatter->process($ret);
    say $text;

=cut

use constant {
    HEADERS_DEFAULT => {
        'Accept'    => 'application/json',
    },
    AGENT_DEFAULT   => 'cif-sdk-perl/'.$CIF::SDK::VERSION,
    TIMEOUT_DEFAULT => 300,
    API_VERSION_DEFAULT	=> 'v2',
    REMOTE_DEFAULT    => 'https://localhost',
};

has 'remote' => (
    is      => 'ro',
    isa     => 'Str',
    reader  => 'get_remote',
    default => REMOTE_DEFAULT().'/'.API_VERSION_DEFAULT(),
);

has 'token' => (
    is      => 'ro',
    isa     => 'Str',
    reader  => 'get_token',
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

has 'nolog' => (
    is      => 'ro',
    isa     => 'Bool',
    reader  => 'get_nolog',
    default => 0,
);

has 'handle' => (
    is      => 'ro',
    isa     => 'HTTP::Tiny',
    reader  => 'get_handle',
    builder => '_build_handle',
);

# helpers

sub BUILD {
    my $self = shift;
    
    unless($Logger){
        init_logging({
            level       => 'WARN',
            category    => 'CIF::SDK::Client',
        });
    }
}           

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



=head1 Object Methods

=head2 new

=head2 search

=over

  $ret = $client->search({ 
      query         => 'example.com', 
      confidence    => 25, 
      limit         => 500
  });

=back

=cut

sub _make_request {
	my $self 	= shift;
	my $uri	 	= shift;
	my $params 	= shift || {};
	
	$uri = $self->get_remote().'/'.$uri;
	
	my $token = $params->{'token'} || $self->get_token();
	
	$uri = $uri.'?token='.$token;

	foreach my $p (keys %$params){
		next unless($params->{$p});
		$uri .= '&'.$p.'='.$params->{$p};
	}
	
	$Logger->debug('uri created: '.$uri);
    $Logger->debug('making request...');
    
    my $resp = $self->get_handle()->get($uri,$params);
    return 'request failed('.$resp->{'status'}.'): '.$resp->{'reason'}.': '.$resp->{'content'} unless($resp->{'status'} eq '200');
    
    $Logger->debug('success, decoding...');
    return undef, decode_json($resp->{'content'});
}

sub search {
    my $self = shift;
    my $args = shift;
    
    my $params = {
    	q 			=> $args->{'query'},
    	limit		=> $args->{'limit'},
    	confidence	=> $args->{'confidence'},
    	token		=> $args->{'token'} || $self->get_token(),
    	group		=> $args->{'group'},
    };
    
    return $self->_make_request('observables',$params);
}

sub search_id {
	my $self 	= shift;
	my $args	= shift;
	
	my $params = {
		id		=> $args->{'id'},
		token	=> $args->{'token'} || $self->get_token(),
	};
	
	return $self->_make_request('observables',$params);
}

=head2 submit

=over

  $ret = $client->submit({ 
      observable    => 'example.com', 
      tlp           => 'green', 
      tags          => ['zeus', 'botnet'], 
      provider      => 'me@example.com' 
  });

=back

=cut

sub submit {
    my $self = shift;
    my $args = shift;
    
    $args = [$args] if(ref($args) eq 'HASH');
    
    $Logger->debug('encoding args...');
    $args = encode_json($args);
    
    my $uri = $self->get_remote().'/observables?token='.$self->get_token();
    
    $Logger->debug('uri generated: '.$uri);
    $Logger->debug('making request...');
    my $resp = $self->get_handle->put($uri,{ content => $args });
    
    $Logger->debug('decoding response..');
    my $content = decode_json($resp->{'content'});

    return $content->{'message'} if($resp->{'status'} > 399);
    
    $Logger->debug('success...');
    return (undef, $content, $resp);
}

=head2 ping

=over

  $ret = $client->ping();

=back

=cut

sub ping {
    my $self = shift;
    $Logger->debug('generating ping...');

    my $t0 = [gettimeofday()];
    
    my $ret = $self->_make_request('ping');
    
    $Logger->debug('sucesss...');
    return undef, tv_interval($t0,[gettimeofday()]);
}

1;
