package CIF::SDK::Client;

use strict;
use warnings FATAL => 'all';

use Mouse;
use HTTP::Tiny;
use CIF::SDK qw/init_logging $Logger/;
use JSON::XS qw(encode_json decode_json);
use Time::HiRes qw(tv_interval gettimeofday);
use Carp;
use Data::Dumper;
use MIME::Base64 qw/encode_base64 decode_base64/;
use Gzip::Faster;
use Try::Tiny;

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
    HEADERS => {
        'Accept'        => 'vnd.cif.v'.$CIF::SDK::API_VERSION.'+json',
        'Content-Type'  => 'application/json',
    },
    AGENT   => 'cif-sdk-perl/'.$CIF::SDK::VERSION,
    TIMEOUT => 1,
    REMOTE  => 'https://localhost',
};

has 'remote' => (
    is      => 'ro',
    default => REMOTE,
);

has [qw(token proxy nolog)] => (
    is  => 'ro'
);

has 'timeout'   => (
    is      => 'ro',
    default => TIMEOUT,
);

has 'headers' => (
    is      => 'ro',
    default => sub { HEADERS },
);

has 'verify_ssl' => (
    is      => 'ro',
    default => 1,
);

has 'nowait' => (
    is      => 'ro',
    default => 0,
);

has 'keep_alive' => (
    is      => 'ro',
    default => 1,
);

has 'handle' => (
    is      => 'ro',
    isa     => 'HTTP::Tiny',
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
        agent           => AGENT,
        default_headers => $self->headers,
        timeout         => $self->timeout,
        verify_ssl      => $self->verify_ssl,
        proxy           => $self->proxy,
        keep_alive      => ($self->nowait) ? 0 : 1, # if we go into nowait mode, the HTTP api might start sending us RSTs
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
	my $route 	= shift;
	my $params 	= shift || {};
	
	$params->{'gzip'} = 1;
	
	my $uri = '';
	
	my $token = $params->{'token'} || $self->token;
	$self->{'headers'}->{'Authorization'} = 'Token token='.$token;

	foreach my $p (keys %$params){
		next unless($params->{$p});
		$params->{$p} =~ s/\s/\%20/g;
		$uri .= $p.'='.$params->{$p}.'&';
	}
	
	$uri =~ s/&$//;
	$uri = '?'.$uri;
	
	$uri = $self->remote.'/'.$route.$uri;
	
	$Logger->debug('uri created: '.$uri);
    $Logger->debug('making request...');
    
    my $resp = $self->handle->request('GET',$uri,$params);
    
    $Logger->info('status: '.$resp->{'status'});
    
    my $size = ($resp->{'headers'}->{'content-length'} / 1024 / 1024); # mb
    if($size < 1){
        $size = '< 1';
    }
    $Logger->info('response size: '.$size . 'MB');

    if($resp->{'headers'}->{'content-type'} && $resp->{'headers'}->{'content-type'} =~ /^application\/json$/){
        $Logger->debug('decoding content..');
        try {
            $Logger->debug('decompressing...');
            my $ret = decode_base64($resp->{'content'});
            $ret = gunzip($ret);
            $resp->{'content'} = $ret;
        } catch {
            my $err = shift;
            $Logger->debug($err);
            unless($err =~ /Data input to gunzip is not in gzip format/){
                die($err);
            }
        };
            
        $resp->{'content'} = decode_json($resp->{'content'});
        if ($resp->{'status'} eq '422'){
            $resp->{'content'} = {"message" => "invalid request" };
        }
    } else {
        if($resp->{'status'} eq '404'){
            $resp->{'content'} = { message => 'uri not found: '.$uri };
        } elsif($resp->{'content'} && $resp->{'content'} ne '') {
            $resp->{'content'} = { message => $resp->{'content'} };
        } else {
            $resp->{'status'} = 404;
            $resp->{'content'} = { message => 'invalid request, check server api version' };
        }
    }
    return $resp;
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
    
    my $resp = $self->_make_request('ping');
    unless($resp->{'status'} eq '200'){
        $Logger->warn($resp->{'content'}->{'message'});
        return undef, $resp->{'content'}->{'message'};
    }
    return tv_interval($t0,[gettimeofday()]);
}

sub ping_write {
    my $self = shift;
    $Logger->debug('generating ping...');

    my $t0 = [gettimeofday()];
    
    my $resp = $self->_make_request('ping', { 'write' => 1 });
    unless($resp->{'status'} eq '200'){
        $Logger->warn($resp->{'content'}->{'message'});
        return undef, $resp->{'content'}->{'message'};
    }
    return tv_interval($t0,[gettimeofday()]);
}

sub aggregate {
    my $self = shift;
    my $args = shift;
    
    my $a = $args->{'aggregate'};
    
    my $h = {};
    my @ret;
    foreach (@{$args->{'data'}}){
        next if(exists($h->{$_->{$a}}));
        push(@ret,$_);
        $h->{$_->{$a}} = 1;
    }
    return \@ret;  
}

sub search {
    my $self = shift;
    my $args = shift;

    my $resp = $self->_make_request('observables',$args);

    unless($resp->{'status'} eq '200'){
        return undef, $resp->{'content'}->{'message'};
    }
    return $resp->{'content'};
}

sub search_id {
	my $self 	= shift;
	my $args	= shift;
	
	my $params = {
		id		=> $args->{'id'},
		token	=> $args->{'token'} || $self->token,
	};
	
	my $resp = $self->_make_request('observables',$params);
	unless($resp->{'status'} eq '200'){
	    $Logger->warn($resp->{'content'}->{'message'});
        return undef, $resp->{'content'}->{'message'};
    }
    return $resp->{'content'};
}

sub search_feed {
    my $self = shift;
    my $args = shift;
    
    my $resp = $self->_make_request('feeds',$args);
    unless($resp->{'status'} eq '200'){
        if($resp->{'status'} gt '500'){
            return undef, $resp->{'content'};
        } else {
            $Logger->warn($resp->{'content'}->{'message'});
            return undef, $resp->{'content'}->{'message'};
        }
    }
    return $resp->{'content'};
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

sub submit_feed {
	my $self = shift;
	my $args = shift;
	
	$args->{'Observables'} = encode_json($args->{'Observables'});

	my $resp = $self->_submit('feeds',$args);
	unless($resp->{'status'} eq '200' or $resp->{'status'} eq '201'){
	    my $err = $resp->{'status'}.': '.$resp->{'reason'};
        $Logger->warn($err);
        return undef, $err;
	}
    return $resp->{'content'}->{'message'};
};

sub submit {
	my $self = shift;
	my $args = shift;
    my $resp = $self->_submit('observables',$args);
    
    unless($resp->{'status'} eq '201' || $resp->{'status'} eq '200'){
        my $err = 'status: '.$resp->{'status'};
        if($resp->{'content'} eq '' && $resp->{'content'}->{'message'}){
            $err = $resp->{'content'}->{'message'};
        }
        return undef, $err;
    }
    return $resp->{'content'};
}

sub _submit {
    my $self = shift;
    my $uri = shift;
    my $args = shift;
    
    $args = [$args] if(ref($args) eq 'HASH');

	$self->{'headers'}->{'Authorization'} = 'Token token='.$self->token;
    
    $Logger->debug('encoding args...');
    
    $args = encode_json($args);
    
    $uri = $self->remote.'/'.$uri;
    
    if($self->nowait){
        $uri .= '?nowait=1';
    }
    
    $Logger->debug('uri generated: '.$uri);
    $Logger->debug('making request...');
    my $resp = $self->handle->request('PUT',$uri,{ content => $args });
    
    unless($resp->{'status'} lt 399){
        $Logger->info($resp->{'reason'});
    } else {
        $Logger->debug('decoding response..');
        $resp->{'content'} = decode_json($resp->{'content'});
    }
    return $resp;
}	


1;
