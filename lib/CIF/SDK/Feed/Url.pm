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
   
    map { $_ = lc(URI->new($_->{'observable'})->canonical->as_string); } @{$args->{'data'}};
    map { $_ = lc(URI->new($_->{'observable'})->canonical->as_string); } @{$args->{'whitelist'}};
   
    my @list;
    
    foreach my $u (@{$args->{'data'}}){
        my $found = 0;
        foreach my $w (@{$args->{'whitelist'}}){
            $found = 1 if($w eq $u);
        }
        push(@list,$u) unless($found)
    }
    return \@list
}

__PACKAGE__->meta()->make_immutable();

1;