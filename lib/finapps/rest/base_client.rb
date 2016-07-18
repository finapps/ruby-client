# frozen_string_literal: true
module FinApps
  module REST
    # base client functionality
    class BaseClient
      include ::FinApps::Utils::Loggeable
      include ::FinApps::REST::Connection
      using ObjectExtensions
      using StringExtensions

      attr_reader :config

      def initialize(options, logger=nil)
        @config = FinApps::REST::Configuration.new options
        @logger = logger
      end

      def user_credentials?
        config.valid_user_credentials?
      end

      # Returns an initialized Faraday connection object.
      #
      # @return Faraday::Connection.
      def connection
        @connection ||= faraday(config, logger)
      end

      # Performs HTTP GET, POST, UPDATE and DELETE requests.
      # You shouldn't need to use this method directly, but it can be useful for debugging.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      # @param [String] path
      # @param [String] method
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def send_request(path, method, params={})
        raise FinApps::MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        raise FinApps::MissingArgumentsError.new 'Missing argument: method.' if method.blank?

        response, error_messages = execute_request(method, params, path)
        result = if response.blank?
                   logger.error "##{__method__} => Null response found. Unable to process it."
                   nil
                 else
                   block_given? ? yield(response) : response.body
                 end

        [result, error_messages]
      end

      private

      def execute_request(method, params, path)
        error_messages = []
        begin
          response = execute_method method, params, path
        rescue FinApps::InvalidArgumentsError,
               FinApps::MissingArgumentsError,
               Faraday::Error::ConnectionFailed => error
          handle_error error
        rescue Faraday::Error::ClientError => error
          error_messages = handle_client_error error
        rescue StandardError => error
          error_messages = handle_standard_error error
        end

        [response, error_messages]
      end

      def handle_error(error)
        logger.fatal "#{self.class}##{__method__} => #{error}"
        raise error
      end

      def handle_client_error(error)
        logger.error "#{self.class}##{__method__} => Faraday::Error::ClientError, #{error}"
        error.response[:error_messages] || [error.message]
      end

      def handle_standard_error(error)
        logger.error "#{self.class}##{__method__} => StandardError, #{error}"
        ['Unexpected error.']
      end

      def execute_method(method, params, path)
        case method
        when :get
          get(path)
        when :post
          post(path, params)
        when :put
          put(path, params)
        when :delete
          delete(path, params)
        else
          raise FinApps::InvalidArgumentsError.new "Method not supported: #{method}."
        end
      end

      # Defines methods to perform HTTP GET, POST, PUT and DELETE requests.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      def method_missing(method_id, *arguments, &block)
        if %i(get post put delete).include? method_id
          connection.send(method_id) do |req|
            req.url arguments.first
            req.body = arguments[1] unless method_id == :get
          end
        else
          super
        end
      end
    end
  end
end
