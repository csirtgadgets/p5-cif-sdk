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
        observable  => 'd67c5cbf5b01c9f91932e3b8def5e5f8',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['botnet','zeus'],
        provider    => 'me@me.com',
        otype       => 'md5',
    },
    {
        observable  => 'b8473b86d4c2072ca9b08bd28e373e8253e865c4',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['botnet','zeus'],
        provider    => 'me@me.com',
        otype       => 'sha1',
    },
    {
        observable  => '3C8727E019A42B444667A587B6001251BECADABBB36BFED8087A92C18882D111',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['botnet','zeus'],
        provider    => 'me@me.com',
        otype       => 'sha256',
    },
    {
        observable  => '6253B39071E5DF8B5098F59202D414C37A17D6A38A875EF5F8C7D89B0212B028692D3D2090CE03AE1DE66C862FA8A561E57ED9EB7935CE627344F742C0931D72',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['botnet','zeus'],
        provider    => 'me@me.com',
        otype       => 'sha512',
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
