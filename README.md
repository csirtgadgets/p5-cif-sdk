# CIF Software Development Kit for Perl
The CIF Software Development Kit (SDK) for Perl contains library code and examples designed to enable developers to build applications using CIF.

[![Build Status](https://travis-ci.org/csirtgadgets/p5-cif-sdk.png?branch=master)](https://travis-ci.org/csirtgadgets/p5-cif-sdk)

# Installation
We highly recomend using Ubuntu 14.04 LTS.
## Ubuntu 14
 ```
 sudo apt-get install -y git build-essential cpanminus libmodule-install-perl
 sudo cpanm http://backpan.perl.org/authors/id/M/MS/MSCHILLI/Log-Log4perl-1.44.tar.gz git://github.com/csirtgadgets/p5-cif-sdk.git 
 ```

# Examples
## Client
### Config
  ```yaml
  # ~/.cif.yml
  client:
    remote: https://localhost
    token: 1234
  ```
### Running
  ```bash
  $ cif --token 1234 --remote 'https://localhost' -q example.com
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

You can also look for information at the [GitHub repo](https://github.com/csirtgadgets/p5-cif-sdk).

# License and Copyright

Copyright (C) 2015 [the CSIRT Gadgets Foundation](http://csirtgadgets.org)

Free use of this software is granted under the terms of the [GNU Lesser General Public License](https://www.gnu.org/licenses/lgpl.html) (LGPL v3.0). For details see the file ``LICENSE`` included with the distribution.

