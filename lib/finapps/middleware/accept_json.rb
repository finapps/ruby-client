# frozen_string_literal: true
module FinApps
  module Middleware
    # This middleware sets the Accept request-header field to specify JSON as acceptable media type for the response.
    class AcceptJson < Faraday::Middleware
      KEY = 'Accept'.freeze unless defined? KEY

      def call(env)
        env[:request_headers][KEY] = 'application/json'
        @app.call(env)
      end
    end
  end
end
