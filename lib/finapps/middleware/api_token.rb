module FinApps
  module Middleware

    class ApiToken < Faraday::Middleware
      include FinApps::Logging

      def initialize(app, options={})
        @app = app
        @options = options
      end

      def call(env)
        raise MissingArgumentsError.new 'Missing argument: company_identifier.' if @options[:company_identifier].blank?
        raise MissingArgumentsError.new 'Missing argument: company_token.' if @options[:company_token].blank?

        header_value = "#{@options[:company_identifier].trim}=#{@options[:company_token].trim}"
        logger.debug "##{__method__.to_s} => Request Header X-FinApps-Token: #{header_value}"
        env[:request_headers]['X-FinApps-Token'] = header_value

        @app.call(env)
      end

    end
  end
end