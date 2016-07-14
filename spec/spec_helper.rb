if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'bundler/setup'
Bundler.setup

require 'finapps'
require 'webmock/rspec'

# noinspection RubyResolve
require File.join(File.dirname(__dir__), 'spec/support/fake_api')

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

  config.before(:each) do
    base_url = "#{FinApps::REST::Defaults::DEFAULTS[:host]}/v#{FinApps::REST::Defaults::API_VERSION}/"
    stub_request(:any, /#{base_url}/).to_rack(::FakeApi)
  end
end

VALID_CREDENTIALS = {identifier: '49fb918d-7e71-44dd-7378-58f19606df2a',
                     token:      'hohoho='}.freeze
