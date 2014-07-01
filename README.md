ruby-client
===========

Ruby client for Finapps
A simple library for communicating with the FinApps REST API.

## Installation

To install using [Bundler][bundler] grab the latest stable version:

```ruby
gem 'finapps'
```

To manually install `finapps` via [Rubygems][rubygems] simply gem install:

```bash
gem install finapps
```

To build and install the development branch yourself from the latest source:

```bash
git clone git@github.com/finapps/ruby-client.git
cd finapps
make install
```

## Usage

### Setup

``` ruby
require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'finapps'

# put your own credentials here
company_identifier = 'my-company-identifier'
company_token = 'my-company-token'

# set up a client to talk to the FinApps REST API
@client = FinApps::REST::Client.new company_identifier, company_token
```

### Create User

``` ruby
@client.users.create(
  :first_name => 'John',
  :last_name => 'Smith',
  :email => 'j.smith@example.com',
  :password => 'myP@ssw0rd',
  :password_confirm => 'myP@ssw0rd'
)
```

### Login User

``` ruby
@client.users.login(
  :email => 'j.smith@example.com',
  :password => 'myP@ssw0rd'
)
```


[builder]: http://builder.rubyforge.org/
[bundler]: http://bundler.io
[rubygems]: http://rubygems.org