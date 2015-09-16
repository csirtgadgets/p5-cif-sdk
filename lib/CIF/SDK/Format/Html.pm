package CIF::SDK::Format::Html;

use strict;
use warnings;

use Mouse;
require HTML::Table;

with 'CIF::SDK::Format';

sub understands {
    my $self = shift;
    my $args = shift;
    return unless($args->{'format'});
    return 1 if($args->{'format'} eq 'html');
}

sub process {
    my $self = shift;
    my $data = shift;
    
    my $table = HTML::Table->new(
        -head           => \@{$self->get_columns()},
        -class          => 'html_class',
        -evenrowclass   => 'html_evenrowclass',
        -oddrowclass    => 'html_oddrowclass',
    );
    
    foreach my $d (@$data){
        my @array;
        foreach my $c (@{$self->get_columns()}){
            my $x = $d->{$c};
            $x = join(',',@$x) if(ref($x) eq 'ARRAY');
            push(@array,$x);
        }
        $table->addRow(@array);
    }
    return $table->getTable();
}

__PACKAGE__->meta()->make_immutable();

1;
