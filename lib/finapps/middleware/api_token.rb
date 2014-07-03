module FinApps
  module Middleware

    class ApiToken < Faraday::Middleware

      def initialize(app, options={}, logger=nil)
        @app = app
        @options = options

        @logger = logger || begin
          require 'logger'
          ::Logger.new(STDOUT).tap do |log|
            # noinspection SpellCheckingInspection
            log.progname = 'FinApps::Middleware::ApiToken'
            log.debug '#initialize => Logger instance created'
          end
        end
      end

      def call(env)
        raise MissingArgumentsError.new 'Missing argument: company_identifier.' if @options[:company_identifier].blank?
        raise MissingArgumentsError.new 'Missing argument: company_token.' if @options[:company_token].blank?

        header_value = "#{@options[:company_identifier].trim}=#{@options[:company_token].trim}"
        env[:request_headers]['X-FinApps-Token'] = header_value
        @logger.debug "FinApps::Middleware::ApiToken#call => Request Header X-FinApps-Token: #{header_value}"

        @app.call(env)
      end

    end
  end
end