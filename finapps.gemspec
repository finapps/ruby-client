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

  spec.add_runtime_dependency 'thor',  '~> 0.19', '>= 0.19.1'
  spec.add_runtime_dependency 'faraday',  '~> 0.9', '>= 0.9.0'
  spec.add_runtime_dependency 'faraday_middleware',  '~> 0.9', '>= 0.9.1'
  spec.add_runtime_dependency 'typhoeus',  '~> 0.6', '>= 0.6.8'
  spec.add_runtime_dependency 'rash', '~> 0.4', '>= 0.4.0'

  spec.add_development_dependency 'bundler', '~> 1.6', '>= 1.6.2'
  spec.add_development_dependency 'rake', '~> 0.9', '>= 0.9.6'
  spec.add_development_dependency 'rspec', '~> 3.0', '>= 3.0.0'

  spec.extra_rdoc_files = %w(README.md LICENSE.txt)
  spec.rdoc_options = %w(--line-numbers --inline-source --title finapps-ruby --main README.md)
end
