use 5.011;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok('CIF::SDK') || print "Bail out!\n";
    use_ok('CIF::SDK::Client') || print "Bail out!\n";
    use_ok('CIF::SDK::FormatFactory') || print "Bail out!\n";
    use_ok('CIF::SDK::Format::Bind') || print "Bail out!\n";
}

my $context = CIF::SDK::Client->new({
    token       => '1234',
    remote      => 'https://localhost/api',
    timeout     => 10,
    verify_ssl  => 0,
});

my $obs = [
    {
        observable  => 'google.com',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['zeus','botnet'],
        provider    => 'me.com',
        otype       => 'fqdn',
    },
    {
        observable  => '000cc.com',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['zeus','botnet'],
        provider    => 'me.com',
        otype       => 'fqdn',
    },
    {
        observable  => '249.strangled.net',
        confidence  => 50,
        tlp         => 'green',
        tags        => ['zeus','botnet'],
        provider    => 'me.com',
        otype       => 'fqdn',
    },
];

my $formatter = CIF::SDK::FormatFactory->new_plugin({ 
        format => 'bind', 
});

my $text = $formatter->process($obs);

ok($text, "testing for feed");
ok($text =~ /google\.com/, "testing feed for google.com");

my @parts = split("\n", $text);

foreach my $p (@parts){
    next if $p =~ /^\/\//;
    ok($p =~ /^zone \S+ {type master; file "/, 'testing output: ' . $p);
}

done_testing();