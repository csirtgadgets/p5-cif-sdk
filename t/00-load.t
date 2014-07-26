use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok('CIF::SDK') || print "Bail out!\n";
    use_ok('CIF::SDK::Client') || print "Bail out!\n";
}

diag( "Testing CIF::SDK $CIF::SDK::VERSION, Perl $], $^X" );

my $context = CIF::SDK::Client->new({
    token       => '1234',
    remote      => 'https://localhost:8443/api',
    timeout     => 10,
    verify_ssl  => 0,
});

ok($context->get_remote() =~ /^https/, 'testing remote...');
ok($context->get_headers()->{'Accept'} =~ /json/, 'testing headers...');
done_testing();
