module FinApps
  module REST
    class Client
      include FinApps::REST::Defaults

      attr_reader :config

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, logger = nil, options = {})

        raise FinApps::REST::MissingArgumentsError.new 'Invalid company_identifier.' if company_identifier.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Invalid company_token.' if company_token.blank?

        @config[:tenant_credentials] = {:identifier => company_identifier, :token => company_token}
        @config = DEFAULTS.merge! options
        @logger = logger || begin
          require 'logger'
          ::Logger.new(STDOUT)
        end
      end

      def connection
        @connection ||= FinApps::REST::Connection.new config
      end

      def users
        @users ||= FinApps::REST::Users.new self
      end

      # Performs HTTP GET, POST, UPDATE and DELETE requests.
      # You shouldn't need to use this method directly, but it can be useful for debugging.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      # @param [String] path
      # @param [String] method
      # @param [Proc] proc
      # @return [Hash,Array<String>]
      def send_request(path, method, params = {}, &proc)
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: method.' if method.blank?

        result, error_messages = nil, []

        begin
          case method
            when :get
              response = get(path)
            when :post
              response = post(path, params)
            when :put
              response = put(path, params)
            when :delete
              response = delete(path, params)
            else
              raise FinApps::REST::InvalidArgumentsError.new "Method not supported: #{method}."
          end

          if response.present?
            result = block_given? ? proc.call(response) : response.body
          else
            logger.error "##{__method__} => Null response found. Unable to process it."
          end

        rescue FinApps::REST::InvalidArgumentsError => error
          raise error
        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
        rescue Faraday::ParsingError => error
          error_messages << 'Unable to parse the server response.'
          logger.error "##{__method__} => Faraday::ParsingError, #{error.to_s}"
        rescue Exception => error
          error_messages << 'Unexpected error.'
          logger.fatal "##{__method__} => Exception, #{error.to_s}"
          logger.fatal error
        ensure
          logger.debug "##{__method__} => Failed, error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
        end

        return result, error_messages
      end

      # @param [String] user_identifier
      # @param [String] user_token
      def user_credentials!(user_identifier, user_token)
        raise FinApps::REST::MissingArgumentsError.new 'Invalid user_identifier.' if user_identifier.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Invalid user_token.' if user_token.blank?

        config[:user_credentials] = {:identifier => user_identifier, :token => user_token}
        @connection = FinApps::REST::Connection.new config
      end

      private

      # Performs an HTTP GET request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @return [Hash,Array<String>]
      def get(path)
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => GET path:#{path}"
        connection.get { |req| req.versioned_url path }
      end

      # Performs an HTTP POST request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def post(path, params = {})
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => POST path:#{path} params:#{skip_sensitive_data params }"
        connection.post do |req|
          req.versioned_url path
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
      def put(path, params = {})
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => PUT path:#{path} params:#{skip_sensitive_data(params)}"
        connection.put do |req|
          req.versioned_url path
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
      def delete(path, params = {})
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__} => DELETE path:#{path} params:#{skip_sensitive_data(params)}"
        connection.delete do |req|
          req.versioned_url path
          req.body = params
        end
      end

    end
  end
end