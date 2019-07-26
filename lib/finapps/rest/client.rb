# frozen_string_literal: true

require 'finapps_core'
require_relative './version'

module FinApps
  module REST
    class Client < FinAppsCore::REST::BaseClient # :nodoc:
      RESOURCES = %i[
        alert_definitions
        alert_occurrences
        consumers_portfolios
        orders
        order_assignments
        order_notifications
        order_refreshes
        order_reports
        order_statuses
        order_tokens
        operators
        operators_password_resets
        password_resets
        products
        portfolios
        portfolios_alerts
        portfolios_available_consumers
        portfolios_consumers
        portfolio_reports
        sessions
        consumers
        tenant_settings
        tenant_app_settings
        version
        plaid_webhooks
      ].freeze

      # @param [String] tenant_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(tenant_token, options = {}, logger = nil)
        not_blank(tenant_token, :tenant_token)

        options[:tenant_token] = tenant_token
        super(options, logger)
      end

      def method_missing(symbol, *arguments, &block)
        if RESOURCES.include? symbol
          class_name = camelize(symbol.to_s)
          variable = "@#{class_name.downcase}"
          unless instance_variable_defined? variable
            klass =
              Object.const_get('FinApps').const_get('REST').const_get class_name
            instance_variable_set(variable, klass.new(self))
          end
          instance_variable_get(variable)
        else
          super
        end
      end

      def respond_to_missing?(method_sym, include_private = false)
        RESOURCES.include?(method_sym) ? true : super
      end

      private

      def camelize(term)
        string = term.to_s
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
        string.gsub(%r{(?:_|(/))([a-z\d]*)}) do
          Regexp.last_match(2).capitalize.to_s
        end
      end
    end
  end
end
