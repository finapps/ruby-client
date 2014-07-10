module FinApps
  module Middleware

    class ApiToken < Faraday::Middleware

      def initialize(app, options={}, logger=nil)
        @app = app
        @options = options
        @logger = logger || begin
          require 'logger' unless defined?(::Logger)
          ::Logger.new(STDOUT).tap do |log|
            # noinspection SpellCheckingInspection
            log.progname = "#{self.class.to_s}"
            log.debug "##{__method__.to_s} => Logger instance created"
          end
        end
      end

      def call(env)
        raise MissingArgumentsError.new 'Missing argument: company_identifier.' if @options[:company_identifier].blank?
        raise MissingArgumentsError.new 'Missing argument: company_token.' if @options[:company_token].blank?

        header_value = "#{@options[:company_identifier].trim}=#{@options[:company_token].trim}"
        env[:request_headers]['X-FinApps-Token'] = header_value

        @logger.debug "##{__method__.to_s} => Request Header X-FinApps-Token: #{header_value}"

        @app.call(env)
      end

    end
  end
end