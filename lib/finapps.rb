# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

require 'finapps_core'
require 'finapps/rest/version'
require 'finapps/rest/consumers'
require 'finapps/rest/sessions'
require 'finapps/rest/order_tokens'
require 'finapps/rest/orders'
require 'finapps/rest/order_reports'
require 'finapps/rest/order_statuses'
require 'finapps/rest/order_notifications'
require 'finapps/rest/password_resets'
require 'finapps/rest/operators'
require 'finapps/rest/operators_password_resets'
require 'finapps/rest/products'
require 'finapps/rest/order_assignments'
require 'finapps/rest/client'
require 'finapps/rest/order_refreshes'
require 'finapps/rest/statements'
require 'finapps/rest/tenant_settings'
require 'finapps/rest/tenant_app_settings'
require 'finapps/rest/portfolios'
require 'finapps/rest/alert_definitions'
require 'finapps/rest/alert_occurrences'
require 'finapps/rest/portfolios_available_consumers'
require 'finapps/rest/portfolios_alerts'
require 'finapps/rest/portfolios_consumers'
require 'finapps/rest/consumers_portfolios'
require 'finapps/rest/portfolio_reports'

require 'finapps/rest/plaid/plaid_resources'
require 'finapps/rest/plaid/plaid_webhooks'
require 'finapps/rest/plaid/plaid_consumer_institutions'

require 'finapps/utils/query_builder'
require 'finapps/version' unless defined?(FinApps::VERSION)
