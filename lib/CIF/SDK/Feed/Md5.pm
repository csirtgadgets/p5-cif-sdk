package CIF::SDK::Feed::Md5;

use strict;
use warnings;

use Mouse;

with 'CIF::SDK::Feed';

sub understands {
    my $self = shift;
    my $args = shift;
      
    return unless($args->{'otype'});
    return 1 if($args->{'otype'} eq 'md5');
}

sub process {
    my $self = shift;
    my $args = shift;
   
    my @wl = @{$args->{'whitelist'}};
    
    my @list;
    
    foreach my $u (@{$args->{'data'}}){
        my $found = 0;
        next if($self->_tag_contains_whitelist($u->{'tags'}));
        foreach my $w (@wl){
            $found = 1 if($w eq $u);
        }
        push(@list,$u) unless($found)
    }
    return \@list
}

__PACKAGE__->meta()->make_immutable();

1;