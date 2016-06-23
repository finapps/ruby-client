module FinApps
  module Middleware

    class TenantAuthentication < Faraday::Middleware

      TENANT_AUTHENTICATION_HEADER = 'X-FinApps-Token'.freeze

      def initialize(app, options={})
        super(app)
        @options = options
      end

      def call(env)
        env[:request_headers][TENANT_AUTHENTICATION_HEADER] ||= header_value
        @app.call(env)
      end

      private

      def header_value
        "#{@options[:company_identifier].strip}=#{@options[:company_token].strip}"
      end

    end

  end
end
