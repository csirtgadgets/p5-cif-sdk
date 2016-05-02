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
        'observable'    => 'gmail-smtp-in.l.google.com',
        'firsttime'     => '2015-07-03T13:58:44Z',
        'tags'          => ['malware'],
        'group'         => 'everyone',
        'tlp'           => 'amber',
        'reporttime'    => '2015-07-03T13:58:44Z',
        'lasttime'      => '2015-07-03T13:58:44Z',
        'otype'         => 'fqdn',
        'provider'      => 'csirtgadgets.org'
    },
    {
        'confidence'    => 100,
        'observable'    => 'google.com',
        'firsttime'     => '2015-07-03T13:58:44Z',
        'tags'          => ['malware'],
        'group'         => 'everyone',
        'tlp'           => 'amber',
        'reporttime'    => '2015-07-03T13:58:44Z',
        'lasttime'      => '2015-07-03T13:58:44Z',
        'otype'         => 'fqdn',
        'provider'      => 'csirtgadgets.org'
    },
    {
        'confidence'    => 100,
        'observable'    => 'badware.com',
        'firsttime'     => '2015-07-03T13:58:44Z',
        'tags'          => ['malware'],
        'group'         => 'everyone',
        'tlp'           => 'amber',
        'reporttime'    => '2015-07-03T13:58:44Z',
        'lasttime'      => '2015-07-03T13:58:44Z',
        'otype'         => 'fqdn',
        'provider'      => 'csirtgadgets.org'
    },
];

my $obj = CIF::SDK::FeedFactory->new_plugin({
	otype => 'fqdn'
});

my $feed = $obj->process({
    data => $data,
    whitelist => [],
});

ok($#{$feed} == 0, 'verifying 1 element...');

my $whitelist = [
    {
        'confidence'    => 100,
        'observable'    => 'google.com',
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

ok($#{$feed} == 0, 'verifying feed');

my $found = 0;
foreach (@{$feed}){
    $found = 1 if($_->{'observable'} eq 'google.com');
    $found = 1 if($_->{'observable'} eq 'gmail-smtp-in.l.google.com');
    $found = 1 if($_->{'observable'} eq 'l.google.com');
}

ok(!$found, 'testing whitelist');
done_testing();
