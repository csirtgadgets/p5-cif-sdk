package CIF::SDK::Feed::Fqdn;

use strict;
use warnings;

use Mouse;
use Net::DNS::Match;

with 'CIF::SDK::Feed';

# arbitrary based on http://www.alexa.com/topsites as of 2014-08
my @perm_whitelist = [
    'google.com',
    'yahoo.com',
    'facebook.com',
    'youtube.com',
    'netflix.com',
    'baidu.com',
    'wikipedia.org',
    'twitter.com',
    'qq.com',
    'taobao.com',
    'amazon.com',
    'live.com',
    'bing.com',
    'wordpress.com',
    'msn.com',
];

sub understands {
    my $self = shift;
    my $args = shift;
    
    return unless($args->{'otype'});
    return 1 if($args->{'otype'} eq 'fqdn');
}

sub process {
    my $self = shift;
    my $args = shift;
    
    my $whitelist = Net::DNS::Match->new();
    $whitelist->add(\@perm_whitelist) unless($args->{'noperm'});
    $whitelist->add($args->{'whitelist'}); ## TODO array or observables?
    
    my @list;
    
    foreach (@{$args->{'data'}}){
        next if($whitelist->match($_->{'observable'}));
        push(@list,$_);
    }
    return \@list
}

__PACKAGE__->meta()->make_immutable();

1;