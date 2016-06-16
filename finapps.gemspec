# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finapps/version'

Gem::Specification.new do |spec|
  spec.name = 'finapps'
  spec.version = FinApps::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Erich Quintero']
  spec.email = ['erich@financialapps.com']

  spec.summary = %q{FinApps REST API ruby client.}
  spec.description = %q{A simple library for communicating with the FinApps REST API.}
  spec.homepage = 'http://github.com/finapps/finapps-ruby'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = Dir['spec/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday',  '~> 0.9', '>= 0.9.2'
  spec.add_runtime_dependency 'faraday_middleware',  '~> 0.10', '>= 0.10.0'
  spec.add_runtime_dependency 'typhoeus',  '~> 1.0', '>= 1.0.1'
  spec.add_runtime_dependency 'rash', '~> 0.4', '>= 0.4.0'

  spec.add_development_dependency 'bundler', '~> 1.11', '>= 1.11.2'
  spec.add_development_dependency 'rake', '~> 11.1', '>= 11.1.2'
  spec.add_development_dependency 'fuubar', '~> 2.0', '>= 2.0.0'
  spec.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  spec.add_development_dependency 'webmock', '~> 1.24', '>= 1.24.2'
  spec.add_development_dependency 'sinatra', '~> 1.4', '>= 1.4.7'
  spec.add_development_dependency 'gem-release', '~> 0.7', '>= 0.7.4'

  spec.extra_rdoc_files = %w(README.md LICENSE.txt)
  spec.rdoc_options = %w(--line-numbers --inline-source --title finapps-ruby --main README.md)
end
