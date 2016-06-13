require 'bundler/setup'
Bundler.setup

require 'finapps'
require 'webmock/rspec'
require File.join(File.dirname(__dir__),  'spec/support/fake_api')

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  config.example_status_persistence_file_path = 'spec/examples.txt'
  #config.disable_monkey_patching!
  config.warnings = true
  config.profile_examples = 5
  Kernel.srand config.seed

  config.before(:each) do
    stub_request(:any, /api.financialapps.com/).to_rack(::FakeApi )
  end
end
