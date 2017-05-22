# frozen_string_literal: true
require 'finapps_core'
require_relative './version'

module FinApps
  module REST
    class Client < FinAppsCore::REST::BaseClient # :nodoc:
      RESOURCES = %i(
        institutions
        institutions_forms
        orders
        order_reports
        order_statuses
        order_tokens
        operators
        password_resets
        products
        sessions
        consumers
        user_institutions
        user_institutions_forms
        user_institutions_statuses
        version
      ).freeze

      # @param [String] tenant_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(tenant_token, options={}, logger=nil)
        not_blank(tenant_token, :tenant_token)

        merged_options = options.merge(tenant_token: tenant_token)
        super(merged_options, logger)
      end

      def method_missing(symbol, *arguments, &block)
        if RESOURCES.include? symbol
          class_name = camelize(symbol.to_s)
          variable = "@#{class_name.downcase}"
          unless instance_variable_defined? variable
            klass = Object.const_get('FinApps').const_get('REST').const_get class_name
            instance_variable_set(variable, klass.new(self))
          end
          instance_variable_get(variable)
        else
          super
        end
      end

      def respond_to_missing?(method_sym, include_private=false)
        RESOURCES.include?(method_sym) ? true : super
      end

      private

      def camelize(term)
        string = term.to_s
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
        string.gsub!(%r{(?:_|(/))([a-z\d]*)}) { $2.capitalize.to_s }
        string
      end
    end
  end
end
