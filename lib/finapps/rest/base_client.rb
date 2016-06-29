module FinApps
  module REST
    class BaseClient # :nodoc:
      include ::FinApps::Utils::Loggeable

      attr_reader :config

      def initialize(options={}, logger=nil)
        @config = FinApps::REST::Configuration.new options
        @logger = logger
      end

      # Returns an initialized Faraday connection object.
      #
      # @return Faraday::Connection.
      def connection
        @connection ||= FinApps::REST::Connection.faraday(config, logger)
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
        result = if response.present?
                   block_given? ? yield(response) : response.body
                 else
                   logger.error "##{__method__} => Null response found. Unable to process it."
                   nil
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
          logger.fatal "##{__method__} => #{error}"
          raise error
        rescue Faraday::Error::ClientError => error
          error_messages = error.response[:error_messages].blank? ? [error.message] : error.response[:error_messages]
          logger.error "##{__method__} => Faraday::Error::ClientError, #{error}"
        rescue StandardError => error
          error_messages << 'Unexpected error.'
          logger.fatal "##{__method__} => StandardError, #{error}"
        end

        [response, error_messages]
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
