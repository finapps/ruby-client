# frozen_string_literal: true

require 'finapps_core'
require_relative './version'

module FinApps
  module REST
    class Client < FinAppsCore::REST::BaseClient # :nodoc:
      RESOURCES = %i[
        actors
        alert_definitions
        alert_occurrences
        consumers
        consumer_login_tokens
        consumers_portfolios
        documents_orders
        documents_orders_notifications
        documents_upload_types
        documents_uploads
        esign_templates
        orders
        order_assignments
        order_notifications
        order_refreshes
        order_reports
        order_statuses
        order_tokens
        operators
        operator_login_tokens
        operators_password_resets
        operator_change_password_email
        password_resets
        plaid_webhooks
        plaid_consumer_institutions
        plaid_accounts
        plaid_account_permissions
        plaid_institution_logos
        portfolios
        portfolios_alerts
        portfolios_available_consumers
        portfolios_consumers
        portfolio_reports
        products
        screenings
        screening_metadatas
        sessions
        signed_documents_downloads
        tenant_settings
        tenant_app_settings
        verix_metadata
        verix_records
        verix_pdf_documents
        verix_documents
        version
      ].freeze

      RESOURCES.each do |method|
        define_method(method) do
          method_definition(method) do |class_name|
            Object.const_get(:FinApps)
                  .const_get(:REST)
                  .const_get(class_name)
          end
        end
      end

      QUERY_RESOURCES = [:query_screenings].freeze

      QUERY_RESOURCES.each do |method|
        define_method(method) do
          class_name = capitalize(method.to_s.gsub(/query_/, ''))
          variable = "@#{method}"

          method_definition(method, class_name, variable) do |_|
            Object.const_get(:FinApps)
                  .const_get(:REST)
                  .const_get(:Query)
                  .const_get(class_name)
          end
        end
      end

      # @param [String] tenant_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(tenant_token, options = {}, logger = nil)
        not_blank(tenant_token, :tenant_token)

        options[:tenant_token] = tenant_token
        super(options, logger)
      end

      private

      def method_definition(method, class_name = nil, variable = nil)
        class_name = camelize(method.to_s) if class_name.nil?
        variable = "@#{class_name.downcase}" if variable.nil?

        unless instance_variable_defined?(variable)
          klass = yield class_name
          instance_variable_set(variable, klass.new(self))
        end
        instance_variable_get(variable)
      end

      def camelize(term)
        string = term.to_s
        string = string.sub(/^[a-z\d]*/) { Regexp.last_match(0).capitalize }
        string.gsub(%r{(?:_|(/))([a-z\d]*)}) { Regexp.last_match(2).capitalize }
      end
    end
  end
end
