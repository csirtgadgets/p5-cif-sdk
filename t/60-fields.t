use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok('CIF::SDK') || print "Bail out!\n";
    use_ok('CIF::SDK::Client') || print "Bail out!\n";
    use_ok('CIF::SDK::FormatFactory') || print "Bail out!\n";
    use_ok('CIF::SDK::Format::Table') || print "Bail out!\n";
}

my $context = CIF::SDK::Client->new({
    token       => '1234',
    remote      => 'https://localhost/api',
    timeout     => 10,
    verify_ssl  => 0,
});

my $obs = [
    {
        observable  => 'http://google.com',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['zeus','botnet'],
        provider    => 'me.com',
        otype       => 'url',
    },
];

my $formatter = CIF::SDK::FormatFactory->new_plugin({ 
        format => 'table',
        columns  => ['observable','tlp']
});
my $text = $formatter->process($obs);

ok($text =~ /^observable\s+\|tlp/, 'testing specified output');
ok($text !~ /^tlp\s+\|group\|reporttime\|observable/, 'testing for default output');

done_testing();