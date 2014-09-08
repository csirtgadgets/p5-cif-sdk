package CIF::SDK::Feed::Ipv6;

use strict;
use warnings;

use Mouse;
use Net::Patricia;

with 'CIF::SDK::Feed';

my @perm_whitelist = (
    ## TODO -- more
    # http://www.iana.org/assignments/ipv6-multicast-addresses/ipv6-multicast-addresses.xhtml
    # v6
    'FF01:0:0:0:0:0:0:1',
    'FF01:0:0:0:0:0:0:2',
);

sub understands {
    my $self = shift;
    my $args = shift;
    
    return unless($args->{'otype'});
    return 1 if($args->{'otype'} eq 'ipv6');
}

sub process {
    my $self = shift;
    my $args = shift;
    
    my $whitelist = Net::Patricia->new();
    $whitelist->add_string($_) foreach @perm_whitelist;
    $whitelist->add_string($_) foreach (@{$args->{'whitelist'}});
    
    my @list;
    
    foreach (@{$args->{'data'}}){
        next if($whitelist->match_string($_->{'observable'}));
        push(@list,$_);
    }
    return \@list
}

__PACKAGE__->meta()->make_immutable();

1;