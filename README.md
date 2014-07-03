FinApps Ruby-Client
===================

Ruby client for [FinApps][financialapps].

A simple library for communicating with the [FinApps][financialapps] REST API.

## Installation

To install using [Bundler][bundler] :

```ruby
# Gemfile
gem 'finapps'
```
then run the command bundle install. 

```bash
bundle install
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
user, error_messages = @client.users.create ({:email => 'j.smith@example.com',
                                             :password => 'Password-1',
                                             :password_confirm => 'Password-1',
                                             :first_name => 'John'
                                             :last_name => 'Smith',
                                             :postal_code => '33021'})
```

### Login User

``` ruby
user, error_messages = @client.users.login ({:email => 'j.smith@example.com',
                                             :password => 'Password-1'})
```


[FinancialApps.com][financialapps]

[builder]: http://builder.rubyforge.org/
[bundler]: http://bundler.io
[rubygems]: http://rubygems.org
[financialapps]: https://financialapps.com