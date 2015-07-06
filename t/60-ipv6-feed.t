use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More skip_all => 'lower levels need some work';
use Data::Dumper;

BEGIN {
    use_ok('CIF::SDK') || print "Bail out!\n";
    use_ok('CIF::SDK::Feed') || print "Bail out!\n";
    use_ok('CIF::SDK::FeedFactory') || print "Bail out!\n";
}

my $data = {
    'confidence'    => 100,
    'observable'    => '2001:503:a83e::2:30',
    'firsttime'     => '2015-07-03T13:58:44Z',
    'tags'          => 'malware',
    'group'         => 'everyone',
    'tlp'           => 'amber',
    'reporttime'    => '2015-07-03T13:58:44Z',
    'lasttime'      => '2015-07-03T13:58:44Z',
    'otype'         => 'ipv6',
    'provider'      => 'csirtgadgets.org'
};

for my $x (qw/ipv6/){
	my $obj = CIF::SDK::FeedFactory->new_plugin({
		otype => $x
	});
	ok($obj);
}

done_testing();
