package CIF::SDK::FormatFactory;

use strict;
use warnings;

use Module::PluginFinder;
use Try::Tiny;
use Carp qw/croak/;

my $finder = Module::PluginFinder->new(
    search_path => ['CIF::SDK::Format'],
    filter      => sub {
        my ($class,$data) = @_;
        $class->understands($data);
    }
);

sub new_plugin {
    my ($self,$args) = @_;
    my $ret;
    try{
        $ret = $finder->construct($args,%{$args}) or die "I don't know how to create this type of Plugin";
    } catch {
        $ret = shift;
        if($ret =~ /Unable to find/){
            $ret = 0;
        } else {
            croak($ret);
        }
    };
    return $ret;
}

1;