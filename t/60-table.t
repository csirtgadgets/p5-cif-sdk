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
    {
        observable  => 'https://google.com/1234.htm',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['zeus','botnet'],
        provider    => 'me.com',
        otype       => 'url',
    },
    {
        observable  => 'google.com/1234.htm',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['zeus','botnet'],
        provider    => 'me.com',
        otype       => 'url',
    },
    {
        observable  => '192.168.1.1',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['zeus','botnet'],
        provider    => 'me.com',
        otype       => 'ipv4',
        portlist    => 1234,
        protocol    => 6
    },  
];

my $formatter = CIF::SDK::FormatFactory->new_plugin({ 
        format => 'table',
});

my $text = $formatter->process($obs);

ok($text, "testing for feed");
ok($text =~ /google.com\/1234.htm/, "testing feed for google.com/1234.htm");
ok($text =~ /1234\.htm/, "testing feed for google.com/1234.htm");

$formatter = CIF::SDK::FormatFactory->new_plugin({ 
        format => 'table',
        columns => ['protocol', 'portlist'],
});

$text = $formatter->process($obs);
ok($text, "testing for feed");
ok($text =~ /TCP/, 'testing for TCP');
ok($text =~ /1234/, 'testing for portlist...');

done_testing();