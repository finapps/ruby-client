# frozen_string_literal: true
require 'finapps/version' unless defined?(FinApps::VERSION)

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

require 'finapps_core'

require 'finapps/rest/version'
require 'finapps/rest/consumers'
require 'finapps/rest/sessions'
require 'finapps/rest/order_tokens'
require 'finapps/rest/orders'
require 'finapps/rest/institutions_forms'
require 'finapps/rest/institutions'
require 'finapps/rest/user_institutions_statuses'
require 'finapps/rest/user_institutions'
require 'finapps/rest/user_institutions_forms'
require 'finapps/rest/order_reports'
require 'finapps/rest/order_statuses'
require 'finapps/rest/password_resets'
require 'finapps/rest/operators'
require 'finapps/rest/operators_password_resets'
require 'finapps/utils/query_builder'

# require 'finapps/rest/configuration'
# require 'finapps/rest/credentials'
# require 'finapps/rest/connection'
# require 'finapps/rest/base_client'
require 'finapps/rest/client'
