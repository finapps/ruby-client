module FinApps
  module Middleware
    # Adds a custom header for tenant level authorization.
    # If the value for this header already exists, it is not overriden.
    class TenantAuthentication < Faraday::Middleware

      TENANT_AUTH_HEADER = 'X-FinApps-Token'.freeze

      def initialize(app, options={})
        super(app)
        @options = options
      end

      def call(env)
        env[:request_headers][TENANT_AUTH_HEADER] ||= header_value
        @app.call(env)
      end

      private

      def header_value
        "#{@options[:company_identifier].strip}=#{@options[:company_token].strip}"
      end

    end
  end
end
