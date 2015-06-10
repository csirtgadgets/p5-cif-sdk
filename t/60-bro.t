use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok('CIF::SDK') || print "Bail out!\n";
    use_ok('CIF::SDK::Client') || print "Bail out!\n";
    use_ok('CIF::SDK::FormatFactory') || print "Bail out!\n";
    use_ok('CIF::SDK::Format::Bro') || print "Bail out!\n";
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
    },  
    {
        observable  => '5bc88c1632ea7857f5990b9ea73f8478',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['botnet','zeus'],
        provider    => 'me@me.com',
        otype       => 'hash',
    },
    {
        observable  => 'me@me.com',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['botnet','zeus'],
        provider    => 'me@me.com',
        otype       => 'email',
    }
];

my $formatter = CIF::SDK::FormatFactory->new_plugin({ 
        format => 'bro', 
});

my $text = $formatter->process($obs);

ok($text, "testing for feed");
ok($text !~ /http:\/\//, "testing for http in feed");
ok($text =~ /google.com\/1234.htm/, "testing feed for google.com/1234.htm");

ok($text =~ /FILE_HASH/, 'testing for hash output');
ok($text =~ /Intel::EMAIL/, 'testing for email output');

done_testing();