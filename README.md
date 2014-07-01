FinApps Ruby-Client
===================

Ruby client for [FinApps][financialapps].

A simple library for communicating with the [FinApps][financialapps] REST API.

## Installation

To install using [Bundler][bundler] grab the latest stable version:

```ruby
gem 'finapps'
```

To manually install `finapps` via [Rubygems][rubygems] simply gem install:

```bash
gem install finapps
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
  :postal_code => '33021',
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


[FinancialApps.com][financialapps]

[builder]: http://builder.rubyforge.org/
[bundler]: http://bundler.io
[rubygems]: http://rubygems.org
[financialapps]: https://financialapps.com