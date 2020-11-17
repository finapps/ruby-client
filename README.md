
FinApps Ruby-Client
===================

[![Gem Version](https://img.shields.io/gem/v/finapps.svg)](https://rubygems.org/gems/finapps)
![Main](https://github.com/finapps/ruby-client/workflows/Main/badge.svg)
[![Build Status](https://travis-ci.org/finapps/ruby-client.svg?branch=master)](https://travis-ci.org/finapps/ruby-client)
[![Code Climate](https://codeclimate.com/github/finapps/ruby-client/badges/gpa.svg)](https://codeclimate.com/github/finapps/ruby-client)
[![Test Coverage](https://codeclimate.com/github/finapps/ruby-client/badges/coverage.svg)](https://codeclimate.com/github/finapps/ruby-client/coverage)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://finapps.mit-license.org)


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

### Release

For approved Pull Requests against the master branch, an aggregated release draft will be generated. This draft by default bumps the patch number of previous version.
Please refer to the [Release Drafter] action documentation for information on this process, specifically and how to bump the major or minor numbers of the gem version.

As soon as this draft is converted into an actual release, an automated process also running on GitHub actions will be triggered to build the gem and release it to rubygems.org.


[FinancialApps.com][financialapps]

[bundler]: http://bundler.io
[financialapps]: https://financialapps.com
[builder]: http://builder.rubyforge.org/
[bundler]: http://bundler.io
[rubygems]: http://rubygems.org
[build_status]: http://teamciti.powerwallet.com/viewType.html?buildTypeId=FaRuby_BuildMaster&guest=1
[Release Drafter]: https://github.com/release-drafter/release-drafter
