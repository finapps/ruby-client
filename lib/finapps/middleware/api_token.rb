module FinApps
  module Middleware

    class ApiToken < Faraday::Middleware
      def initialize(app, options={})
        @app = app
        @options = options
      end

      def call(env)

        company_identifier = @options[:company_identifier]
        company_token = @options[:company_token]



        env[:request_headers]['X-FinApps-Token'] = "#{company_identifier.trim}=#{company_token.trim}" unless company_identifier.nil? || company_token.nil?

        @app.call(env)
      end

    end
  end
end