#!perl -T

use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;

# https://developer.github.com/v3/

BEGIN {
    use_ok( 'CIF::SDK' ) || print "Bail out!\n";
    use_ok('CIF::SDK::Client') || print "Bail out!\n";
}

diag( "Testing CIF::SDK $CIF::SDK::VERSION, Perl $], $^X" );

my $context = CIF::SDK::Client->new({
    token   => '1234',
    port    => 8080,
    host    => 'http://localhost',
    timeout => 10,
});

my ($err,$ret);
($err,$ret) = $context->submit({
    observable  => 'example.com',
    confidence  => 50,
    tlp         => 'green',
    tags        => ['zeus','botnet'],
    provider    => 'me.com',
    
});
warn $err if($err);


done_testing();
