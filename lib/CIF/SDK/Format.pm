package CIF::SDK::Format;

use strict;
use warnings;

use Mouse::Role;

requires qw/understands process/;

use constant DEFAULT_COLS   => [ 
    'tlp','group','lasttime','observable','cc','confidence','tags','rdata','provider'
];

use constant DEFAULT_SORT   => [
    { 'lasttime'    => 'ASC' },
    { 'firsttime'   => 'ASC' },
];

has 'columns'   => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { DEFAULT_COLS() },
    reader  => 'get_columns',
);

has 'sort'  => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { DEFAULT_SORT() },
);

1;