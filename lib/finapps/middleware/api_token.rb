module FinApps
  module Middleware

    class ApiToken < Faraday::Middleware
      include FinApps::Logging

      def initialize(app, options={})
        @app = app
        @options = options
      end

      def call(env)
        company_identifier = @options[:company_identifier].trim
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: company_identifier.' if company_identifier.blank?

        company_token = @options[:company_token].trim
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: company_token.' if company_token.blank?

        env[:request_headers]['X-FinApps-Token'] = "#{company_identifier}=#{company_token}"
        @app.call(env)
      end

    end

  end
end
