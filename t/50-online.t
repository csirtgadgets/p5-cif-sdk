#!perl -T

use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;

BEGIN {
    if($ENV{'ONLINE_TESTS'}){
        use_ok('CIF::SDK') || print "Bail out!\n";
        use_ok('CIF::SDK::Client') || print "Bail out!\n";
    } else {
        plan( skip_all => 'skipping online tests');
    }
}

my $context = CIF::SDK::Client->new({
    token       => '1234',
    remote      => 'https://localhost:8443/api',
    timeout     => 10,
    verify_ssl  => 0,
});

my ($err,$ret) = $context->submit({
    observable  => 'example.com',
    confidence  => 50,
    tlp         => 'green',
    tags        => ['zeus','botnet'],
    provider    => 'me.com',
    
});
ok($ret, 'testing submit');
diag(Dumper($ret));

done_testing();