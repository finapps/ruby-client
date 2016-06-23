require 'finapps/version' unless defined?(FinApps::VERSION)

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'finapps/core_ext/object/blank'
require 'finapps/core_ext/hash/compact'

require 'finapps/middleware/tenant_authentication'
require 'finapps/middleware/raise_http_exceptions'

require 'finapps/rest/defaults'
require 'finapps/rest/errors'

require 'finapps/rest/resource'
require 'finapps/rest/resources'

require 'finapps/rest/users'


require 'finapps/rest/connection'
require 'finapps/rest/client'
