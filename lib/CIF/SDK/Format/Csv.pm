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
    my $data = shift;

    my @text;
    my $header = join(',',@{$self->get_columns()});
    push(@text,$header);
    
    foreach my $d (@$data){
        my @array;
        foreach my $c (@{$self->get_columns()}){
            my $x = $d->{$c} || '';
            $x = join('|',@$x) if(ref($x) eq 'ARRAY');
            push(@array,$x);
        }
        push(@text,join(',',@array));
    }
    return $header unless($#text > -1);
    return join("\n",@text);
}

__PACKAGE__->meta()->make_immutable();

1;
