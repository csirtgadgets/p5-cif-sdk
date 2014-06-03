# CIF Software Development Kit for Perl
The CIF Software Development Kit (SDK) for Perl contains library code and examples designed to enable developers to build applications using CIF.

[![Build Status](https://travis-ci.org/csirtgadgets/p5-cif-sdk.png?branch=master)](https://travis-ci.org/csirtgadgets/p5-cif-sdk)

# Installation

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install
	
# Examples
## Client
  ```bash
  $ cif -T 1234 -R 'https://localhost/api' -q example.com
  ```
  
## API
### Search
  ```perl
  use CIF::SDK qw/init_logging $Logger/;
  use CIF::SDK::Client;
  use CIF::SDK::FormatFactory;

  my $loglevel = ($debug) ? 'DEBUG' : 'WARN';

  init_logging(
      { 
          level       => $loglevel,
          category	=> 'cif',
      },
  );

  $Logger->info('starting client...');

  my $cli = CIF::SDK::Client->new({
    token       => $token,
    remote      => $remote,
    timeout     => $timeout,
  });
 
  $Logger->info('running search...');
  my ($err,$ret) = $cli->search({
  	query       => $query,
        confidence  => $confidence,
        limit       => $limit,
  });
  
  $Logger->info('formatting results...');
  my $formatter = CIF::SDK::FormatFactory->new_plugin({ format => 'table' });
  my $text = $formatter->process($ret);
  print $text."\n";
  ```
### Ping
  ```perl
  use feature 'say';
  use CIF::SDK::Client;
  
  ...
  
  my $ret = $cli->ping();
  say 'roundtrip: '.$ret.' ms';
  ```

# Support and Documentation

After installing, you can find documentation for this module with the
perldoc command.

    perldoc CIF::SDK
    perldoc CIF::SDK::Client

You can also look for information at:

   https://github.com/csirtgadgets/cif-sdk-perl


# License and Copyright

Copyright (C) 2014 [the CSIRT Gadgets Foundation](http://csirtgadgets.org)

Free use of this software is granted under the terms of the GNU Lesser General Public License (LGPLv3). For details see the files COPYING included with the distribution.

