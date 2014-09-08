package CIF::SDK::Feed::Url;

use strict;
use warnings;

use Mouse;

with 'CIF::SDK::Feed';

use URI;

sub understands {
    my $self = shift;
    my $args = shift;
      
    return unless($args->{'otype'});
    return 1 if($args->{'otype'} eq 'url');
}

sub process {
    my $self = shift;
    my $args = shift;
   
    ## TODO -- finish (compare whitelist)
   
    map { $_ = URI->new($_)->canonical(); } @{$args->{'data'}};
    map { $_ = URI->new($_)->canonical(); } @{$args->{'whitelist'}};
   
    my @list;
    
#    foreach (@{$args->{'data'}}){
#        push(@list,$_);
#    }
    return \@list
}

__PACKAGE__->meta()->make_immutable();

1;