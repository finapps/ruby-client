module FinApps
  module REST
    class Client # :nodoc:
      include FinApps::REST::Defaults

      RUBY = "#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".freeze

      HEADERS = {
        accept:     'application/json',
        user_agent: "finapps-ruby/#{FinApps::VERSION} (#{RUBY})"
      }.freeze

      attr_reader :config

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, logger=nil, options={})
        raise FinApps::REST::MissingArgumentsError.new 'Invalid company_identifier.' if company_identifier.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Invalid company_token.' if company_token.blank?

        merged_options = FinApps::REST::Defaults::DEFAULTS.merge options
        merged_options[:tenant_credentials] = {identifier: company_identifier, token: company_token}

        @config = FinApps::REST::Configuration.new merged_options
        @logger = logger || begin
          require 'logger'
          ::Logger.new(STDOUT)
        end
      end

      def connection
        @connection ||= faraday_connection
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
      def send_request(path, method, params={})
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: method.' if method.blank?

        result = nil
        error_messages = []

        begin
          response = execute_method method, params, path
          if response.present?
            result = block_given? ? yield(response) : response.body
          else
            logger.error "##{__method__} => Null response found. Unable to process it."
          end

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
          if error_messages.present?
            logger.debug "##{__method__} => Failed, error_messages: #{error_messages.pretty_inspect}"
          end
        end

        [result, error_messages]
      end

      # @param [String] user_identifier
      # @param [String] user_token
      def user_credentials!(user_identifier, user_token)
        raise FinApps::REST::MissingArgumentsError.new 'Invalid user_identifier.' if user_identifier.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Invalid user_token.' if user_token.blank?

        @config[:user_credentials] = {identifier: user_identifier, token: user_token}
        @connection = faraday_connection
      end

      private

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
          raise FinApps::REST::InvalidArgumentsError.new "Method not supported: #{method}."
        end
      end

      def faraday_connection
        Faraday.new(faraday_options) do |conn|
          # tenant level authentication
          conn.use FinApps::Middleware::TenantAuthentication, config.tenant_credentials

          # user level authentication
          if config.valid_user_credentials?
            conn.request :basic_auth, config.user_credentials[:identifier], config.user_credentials[:token]
          end

          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
          conn.use FinApps::Middleware::RaiseHttpExceptions
          conn.response :rashify
          conn.response :json, content_type: /\bjson$/
          conn.response :logger, logger, bodies: true

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end
      end

      def faraday_options
        {url:     config.versioned_url,
         request: {open_timeout: config.timeout, timeout: config.timeout},
         headers: {accept: HEADERS[:accept], user_agent: HEADERS[:user_agent]}}
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
        connection.get {|req| req.versioned_url path }
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

        logger.debug "##{__method__} => POST path:#{path} params:#{skip_sensitive_data params}"
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
      def put(path, params={})
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
      def delete(path, params={})
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
