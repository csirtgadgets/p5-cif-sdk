package CIF::SDK::Feed;

use strict;
use warnings;

use Mouse::Role;

requires qw/understands process/;

has 'whitelist' => (
    is  => 'ro',
);

has 'data' => (
    is  => 'ro',
);

has [qw(otype confidence group tags tlp)] => (
    is  => 'ro',
);

sub _tag_contains_whitelist {
    my $self = shift;
    my $tags = shift;
    
    return 0 unless($tags);
    
    foreach (@$tags){
        return 1 if $_ eq 'whitelist'
    }
    return 0;
}

1;