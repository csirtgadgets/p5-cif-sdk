package CIF::SDK::Format::Csv;

use strict;
use warnings;
use namespace::autoclean;

use Mouse;

with 'CIF::SDK::Format';

sub understands {
    my $self = shift;
    my $args = shift;

    return unless($args->{'format'});
    return 1 if($args->{'format'} eq 'csv');
}

sub process {
    my $self = shift;
    my $args = shift;

}

__PACKAGE__->meta()->make_immutable();

1;
