[![Gem Version](http://img.shields.io/gem/v/finapps.svg)][gem]
![Build Status](http://teamciti.powerwallet.com/app/rest/builds/buildType:(id:FaRuby_BuildMaster)/statusIcon)


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



## Getting started with FinApps REST client

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

## More Information

Please check the [FinApps wiki][wiki] for extended documentation.


[FinancialApps.com][financialapps]


[bundler]: http://bundler.io
[financialapps]: https://financialapps.com
[wiki]: https://github.com/finapps/ruby-client/wiki
[builder]: http://builder.rubyforge.org/
[wiki]: https://github.com/twilio/twilio-ruby/wiki
[bundler]: http://bundler.io
[rubygems]: http://rubygems.org
[gem]: https://rubygems.org/gems/finapps
