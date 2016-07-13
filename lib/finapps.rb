require 'finapps/version' unless defined?(FinApps::VERSION)

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'active_support/core_ext/hash/compact'
require 'active_support/core_ext/object/blank'
require 'finapps/core_extensions/integerable'
require 'finapps/hash_constructable'
require 'finapps/utils/loggeable'
require 'finapps/error'

require 'finapps/middleware/tenant_authentication'
require 'finapps/middleware/raise_error'

require 'finapps/rest/defaults'
require 'finapps/rest/resources'

require 'finapps/rest/users'
require 'finapps/rest/orders'

require 'finapps/rest/configuration'
require 'finapps/rest/connection'
require 'finapps/rest/base_client'
require 'finapps/rest/client'
