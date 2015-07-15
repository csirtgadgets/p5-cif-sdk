use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok('CIF::SDK') || print "Bail out!\n";
    use_ok('CIF::SDK::Feed') || print "Bail out!\n";
    use_ok('CIF::SDK::FeedFactory') || print "Bail out!\n";
}

my $data = [
    {
        'confidence'    => 100,
        'observable'    => '2001:4860:4860::8888',
        'firsttime'     => '2015-07-03T13:58:44Z',
        'tags'          => ['malware'],
        'group'         => 'everyone',
        'tlp'           => 'amber',
        'reporttime'    => '2015-07-03T13:58:44Z',
        'lasttime'      => '2015-07-03T13:58:44Z',
        'otype'         => 'ipv6',
        'provider'      => 'csirtgadgets.org'
    },
];

my $obj = CIF::SDK::FeedFactory->new_plugin({
	otype => 'ipv6'
});

my $feed = $obj->process({
    data => $data,
    whitelist => [],
});

ok($#{$feed} == 0, 'verifying 1 element...');

my $whitelist = [
    {
        'confidence'    => 100,
        'observable'    => '2001:4860:4860::8888',
        'firsttime'     => '2015-07-03T13:58:44Z',
        'tags'          => ['whitelist'],
        'group'         => 'everyone',
        'tlp'           => 'amber',
        'reporttime'    => '2015-07-03T13:58:44Z',
        'lasttime'      => '2015-07-03T13:58:44Z',
        'otype'         => 'ipv6',
        'provider'      => 'csirtgadgets.org'
    },
];

$feed = $obj->process({
    data => $data,
    whitelist => $whitelist,
});

ok($#{$feed} == -1, 'verifying no data');
done_testing();
