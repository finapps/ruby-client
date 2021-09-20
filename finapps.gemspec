# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finapps/version'
Gem::Specification.new do |spec|
  spec.name = 'finapps'
  spec.version = FinApps::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Erich Quintero']
  spec.email = ['erich@financialapps.com']

  spec.summary = 'FinApps REST API ruby client.'
  spec.description = 'A simple library for communicating with the FinApps REST API.'
  spec.homepage = 'https://github.com/finapps/ruby-client'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files = Dir['spec/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency     'finapps_core',               '~> 6.0',   '>= 6.0.1'

  spec.add_development_dependency 'bundler',                    '~> 2.2',   '>= 2.2.16'
  spec.add_development_dependency 'rake',                       '~> 13.0',  '>= 13.0.1'
  spec.add_development_dependency 'rspec',                      '~> 3.10',  '>= 3.10.0'
  spec.add_development_dependency 'rubocop-performance',        '~> 1.11',  '>= 1.11.5'
  spec.add_development_dependency 'rubocop-rake',               '~> 0.5',   '>= 0.5.1'
  spec.add_development_dependency 'rubocop-rspec',              '~> 2.4',   '>= 2.4.0'
  spec.add_development_dependency 'simplecov',                  '~> 0.21',  '>= 0.21.2'
  spec.add_development_dependency 'simplecov-console',          '~> 0.9'
  spec.add_development_dependency 'sinatra',                    '~> 2.1',   '>= 2.1.0'
  spec.add_development_dependency 'webmock',                    '~> 3.14',  '>= 3.14.0'

  spec.extra_rdoc_files = %w[README.md LICENSE.txt]
  spec.rdoc_options = %w[--line-numbers --inline-source --title finapps-ruby --main README.md]
end
