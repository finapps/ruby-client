require 'finapps/version' unless defined?(FinApps::VERSION)
require 'logger' unless defined?(::Logger)

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'finapps/rest/defaults'
require 'finapps/rest/errors'
require 'finapps/utils/utils'
require 'finapps/rest/base'
require 'finapps/rest/error_messages'
require 'finapps/rest/users'
require 'finapps/middleware/api_token'
require 'finapps/middleware/raise_http_exceptions'
require 'finapps/rest/client'
