# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'simplecov-console'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::Console,
  ]

  SimpleCov.start do
    track_files 'lib/**/*.rb'
  end

  puts "Using SimpleCov v#{SimpleCov::VERSION}"
end

require 'bundler/setup'
Bundler.setup

require 'finapps'
require 'webmock/rspec'

# noinspection RubyResolve
require File.join(File.dirname(__dir__), 'spec/support/fake_api')
require File.join(File.dirname(__dir__), 'spec/spec_helpers/client')
require File.join(File.dirname(__dir__), 'spec/spec_helpers/api_request')

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end
  config.mock_with(:rspec) {|mocks| mocks.verify_partial_doubles = true }
  # config.filter_run_including :focus => true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.warnings = true
  Kernel.srand config.seed

  config.before do
    base_url =
      "#{FinAppsCore::REST::Defaults::DEFAULTS[:host]}/v#{FinAppsCore::REST::Defaults::API_VERSION}/"
    stub_request(:any, /#{base_url}/).to_rack(::Fake::FakeApi)
  end
  WebMock.disable_net_connect!(allow: 'codeclimate.com')
end

VALID_CREDENTIALS = {
  identifier: '49fb918d-7e71-44dd-7378-58f19606df2a', token: 'hohoho='
}.freeze

RESULTS = 0
ERROR_MESSAGES = 1

def versioned_api_path
  "#{FinAppsCore::REST::Defaults::DEFAULTS[:host]}/v#{FinAppsCore::REST::Defaults::API_VERSION}"
end
