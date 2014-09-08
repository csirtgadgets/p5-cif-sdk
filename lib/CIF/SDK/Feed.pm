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

1;