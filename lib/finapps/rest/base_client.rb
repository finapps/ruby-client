module FinApps
  module REST
    class BaseClient # :nodoc:
      attr_reader :config

      def initialize(options, logger=nil)
        @config = FinApps::REST::Configuration.new options
        @logger = logger || begin
          require 'logger'
          ::Logger.new(STDOUT)
        end
      end

      def connection
        @connection ||= FinApps::REST::Connection.faraday(config)
      end

      private

      def execute_request(method, params, path)
        error_messages = []

        begin
          response = execute_request_internal method, params, path

        rescue FinApps::REST::InvalidArgumentsError => error
          raise error
        rescue FinApps::REST::MissingArgumentsError => error
          raise error
        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
        rescue Faraday::ParsingError => error
          error_messages << 'Unable to parse the server response.'
          logger.fatal "##{__method__} => Faraday::ParsingError, #{error}"
        rescue StandardError => error
          error_messages << 'Unexpected error.'
          logger.fatal "##{__method__} => Error, #{error}"
        ensure
          logger.debug "##{__method__} => Failed, error_messages: #{error_messages}" if error_messages.present?
        end

        [response, error_messages]
      end

      def execute_request_internal(method, params, path)
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
          raise FinApps::REST::InvalidArgumentsError.new "Method not supported: #{method}."
        end
      end

      # Performs an HTTP GET request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @return [Hash,Array<String>]
      def get(path)
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => GET path:#{path}"
        connection.get {|req| req.url path }
      end

      # Performs an HTTP POST request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def post(path, params={})
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => POST path:#{path} params:#{params}"
        connection.post do |req|
          req.url path
          req.body = params
        end
      end

      # Performs an HTTP PUT request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def put(path, params={})
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => PUT path:#{path} params:#{params}"
        connection.put do |req|
          req.url path
          req.body = params
        end
      end

      # Performs an HTTP DELETE request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def delete(path, params={})
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => DELETE path:#{path} params:#{params}"
        connection.delete do |req|
          req.url path
          req.body = params
        end
      end
    end
  end
end
