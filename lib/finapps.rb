require 'finapps/version' unless defined?(FinApps::VERSION)

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'core_extensions/hash/compact'
require 'core_extensions/object/blank'
require 'core_extensions/object/is_integer'
require 'finapps/utils/loggeable'
require 'finapps/error'

require 'finapps/middleware/tenant_authentication'
require 'finapps/middleware/accept_json'
require 'finapps/middleware/user_agent'
require 'finapps/middleware/raise_error'
require 'finapps/middleware/middleware'

require 'finapps/rest/defaults'
require 'finapps/rest/resources'

require 'finapps/rest/users'
require 'finapps/rest/orders'

require 'finapps/rest/configuration'
require 'finapps/rest/credentials'
require 'finapps/rest/connection'
require 'finapps/rest/base_client'
require 'finapps/rest/client'
