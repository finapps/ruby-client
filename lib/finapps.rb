# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

require 'finapps_core'
require 'finapps/rest/actors'
require 'finapps/rest/edm_transmissions'
require 'finapps/rest/version'
require 'finapps/rest/locations'
require 'finapps/rest/consumers'
require 'finapps/rest/consumer_login_tokens'
require 'finapps/rest/sessions'
require 'finapps/rest/order_tokens'
require 'finapps/rest/orders'
require 'finapps/rest/order_reports'
require 'finapps/rest/order_statuses'
require 'finapps/rest/order_notifications'
require 'finapps/rest/password_resets'
require 'finapps/rest/operators'
require 'finapps/rest/operator_login_tokens'
require 'finapps/rest/operators_password_resets'
require 'finapps/rest/operator_change_password_email'
require 'finapps/rest/products'
require 'finapps/rest/order_assignments'
require 'finapps/rest/client'
require 'finapps/rest/order_refreshes'
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
require 'finapps/rest/documents_orders'
require 'finapps/rest/documents_uploads'
require 'finapps/rest/esign_templates'
require 'finapps/rest/documents_upload_types'
require 'finapps/rest/signed_documents_downloads'
require 'finapps/rest/documents_orders_notifications'
require 'finapps/rest/screenings'
require 'finapps/rest/states'
require 'finapps/rest/screening_metadatas'

require 'finapps/rest/plaid/plaid_resources'
require 'finapps/rest/plaid/plaid_webhooks'
require 'finapps/rest/plaid/plaid_consumer_institutions'
require 'finapps/rest/plaid/plaid_accounts'
require 'finapps/rest/plaid/plaid_account_permissions'
require 'finapps/rest/plaid/plaid_institution_logos'

require 'finapps/rest/verix/verix_metadata'
require 'finapps/rest/verix/verix_records'
require 'finapps/rest/verix/verix_pdf_documents'
require 'finapps/rest/verix/verix_documents'

require 'finapps/rest/query/base'
require 'finapps/rest/query/screenings'
require 'finapps/rest/query/users'

require 'finapps/utils/query_builder'
require 'finapps/version' unless defined?(FinApps::VERSION)
