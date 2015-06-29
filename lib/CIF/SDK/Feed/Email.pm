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
   
    my @list;
    
    foreach (@{$args->{'data'}}){
        my $found = 0;
        next if($self->_tag_contains_whitelist($_->{'tags'}));
        foreach my $w (@{$args->{'whitelist'}}){
            $found = 1 if($w eq $_);
        }
        push(@list,$_) unless($found);
    }
    return \@list
}

__PACKAGE__->meta()->make_immutable();

1;