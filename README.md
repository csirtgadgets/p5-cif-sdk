# CIF Software Development Kit for Perl
[![Build Status](https://travis-ci.org/csirtgadgets/cif-sdk-perl.png?branch=master)](https://travis-ci.org/csirtgadgets/cif-sdk-perl)

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
  use feature 'say';
  use CIF::SDK::Client;
  use CIF::SDK::FormatFactory;

  my $cli = CIF::SDK::Client->new({
    token       => $token,
    remote      => $remote,
    timeout     => $timeout,
  });

  my ($err,$ret) = $cli->search({
  	query       => $query,
        confidence  => $confidence,
        limit       => $limit,
  });

  my $formatter = CIF::SDK::FormatFactory->new_plugin({ format => 'table' });
  my $text = $formatter->process($ret);
  say $text;
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

You can also look for information at:

   https://github.com/csirtgadgets/cif-sdk-perl


## License and Copyright

Copyright (C) 2014 "Wes Young" <wes@barely3am.com>

Free use of this software is granted under the terms of the GNU Lesser General Public License (LGPLv3). For details see the files COPYING included with the distribution.

