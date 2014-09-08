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

for my $x (qw/ipv4 ipv6 fqdn url email/){
	my $obj = CIF::SDK::FeedFactory->new_plugin({
		otype => $x
	});
	ok($obj);
}

done_testing();
