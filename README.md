FinApps Ruby-Client
===================

Ruby client for [FinApps][financialapps].

A simple library for communicating with the [FinApps][financialapps] REST API.



## Installation


To install using [Bundler][bundler], add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'finapps'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install finapps
```



## Usage

### Setup

You will need to authenticate every API call using your FinApps company credentials. 

Please visit [FinApps][financialapps] if you still haven't setup your account with Financial Apps or have any issues locating your company credentials.


``` ruby
require 'finapps'

# replace with your own credentials here
company_identifier = 'my-company-identifier'
company_token = 'my-company-token'

# set up a client to talk to the FinApps REST API
@client = FinApps::REST::Client.new company_identifier, company_token
```




[FinancialApps.com][financialapps]


[bundler]: http://bundler.io
[financialapps]: https://financialapps.com