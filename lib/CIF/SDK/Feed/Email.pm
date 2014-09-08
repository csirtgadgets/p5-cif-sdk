package CIF::SDK::Feed::Email;

use strict;
use warnings;

use Mouse;

with 'CIF::SDK::Feed';

use URI;

sub understands {
    my $self = shift;
    my $args = shift;

    return unless($args->{'otype'});
    return 1 if($args->{'otype'} eq 'email');
}

sub process {
    my $self = shift;
    my $args = shift;
   
    map { $_ = URI->new($_)->canonical(); } @{$args->{'data'}};
    map { $_ = URI->new($_)->canonical(); } @{$args->{'whitelist'}};
   
    my @list;
    
      
    ## TODO -- finish (compare whitelist)
    
#    foreach (@{$args->{'data'}}){
#        push(@list,$_);
#    }
    return \@list
}

__PACKAGE__->meta()->make_immutable();

1;