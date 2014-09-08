require 'finapps/version' unless defined?(FinApps::VERSION)
require 'logger' unless defined?(::Logger)
require 'pp'

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'finapps/rest/defaults'
require 'finapps/rest/errors'
require 'finapps/utils/logging'
require 'finapps/utils/utils'
require 'finapps/middleware/api_token'
require 'finapps/middleware/raise_http_exceptions'
require 'finapps/middleware/response_logger'

require 'finapps/rest/resource'
require 'finapps/rest/resources'
require 'finapps/rest/users'
require 'finapps/rest/institutions'
require 'finapps/rest/user_institutions'
require 'finapps/rest/transactions'
require 'finapps/rest/categories'
require 'finapps/rest/geo'

require 'finapps/rest/connection'
require 'finapps/rest/client'
