# frozen_string_literal: true
module FinApps
  module Middleware
    # Adds a custom header for basic authorization.
    # If the value for this header already exists, it is not overriden.
    class NoEncodingBasicAuthentication < Faraday::Middleware
      KEY = 'Authorization' unless defined? KEY

      def initialize(app, token)
        super(app)
        sanitized = token.to_s.strip.delete("\n")
        @header_value = "Basic #{sanitized}"
      end

      def call(env)
        env[:request_headers][KEY] ||= @header_value
        @app.call(env)
      end
    end
  end
end
