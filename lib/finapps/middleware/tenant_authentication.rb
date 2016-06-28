module FinApps
  module Middleware
    # Adds a custom header for tenant level authorization.
    # If the value for this header already exists, it is not overriden.
    class TenantAuthentication < Faraday::Middleware
      KEY = 'X-FinApps-Token'.freeze unless defined? KEY

      def initialize(app, options={})
        super(app)
        @header_value = "#{options[:identifier].strip}=#{options[:token].strip}"
      end

      def call(env)
        env[:request_headers][KEY] ||= @header_value
        @app.call(env)
      end
    end
  end
end
