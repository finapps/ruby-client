module FinApps
  module REST
    class Client

      include FinApps::REST::Defaults
      attr_reader :users

      class << self
        attr_accessor :logger

        def logger
          @logger ||= ::Logger.new(STDOUT)
        end
      end

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, options = {})

        # host url must be defined
        @config = DEFAULTS.merge! options
        validate_host_url!

        # company credentials are required for every API call
        @company_credentials = {:company_identifier => company_identifier.trim, :company_token => company_token.trim}
        validate_company_credentials!

        set_up_connection
        set_up_resources

        #logger.level = options[:log_level]
        #logger.debug 'FinApps::REST#Client => initialized'
      end

      # Perform an HTTP GET request
      def get(path, params = {})
        #logger.debug "FinApps::REST#Client => GET, #{path} : #{params}"
        @connection.get do |req|
          req.url path
        end
      end

      # Perform an HTTP POST request
      def post(path, params = {})
        ::Logger.new(STDOUT).debug "FinApps::REST#Client => POST, #{path} : #{params}"

        @connection.post do |req|
          req.url path
          req.body = params
        end

      end

      private
      def set_up_connection
        #logger.debug 'set_up_connection, Started'

        base_url = @config[:host]
        base_url = "#{base_url}/v#{API_VERSION}"

        timeout = @config[:timeout].blank? ? DEFAULTS[:timeout] : @config[:timeout]
        user_identifier = @config[:user_identifier]
        user_token = @config[:user_token]

        @connection = Faraday.new(:url => base_url,
                                  :request => {
                                      :open_timeout => timeout,
                                      :timeout => timeout},
                                  :headers => {
                                      :accept => HEADERS[:accept],
                                      :user_agent => HEADERS[:user_agent]}) do |conn|

          # Request Middleware
          conn.use FinApps::Middleware::ApiToken, @company_credentials
          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
          if user_identifier.blank? || user_token.blank?
            #logger.debug 'Authentication header not set.'
          else
            conn.request :basic_auth, user_identifier, user_token
            #logger.debug "Authentication header set for user identifier: #{user_identifier}"
          end

          # Response Middleware
          conn.use FinApps::Middleware::RaiseHttpExceptions
          conn.response :rashify
          conn.response :json, :content_type => /\bjson$/
          conn.response :logger

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end

        #logger.debug 'set_up_connection, Completed'
      end

      # Returns a Faraday::Connection object
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= set_up_connection
      end

      def set_up_resources
        @users ||= FinApps::REST::Users.new self
      end

      def validate_company_credentials!
        @company_credentials.each do |credential, value|
          raise MissingArgumentsError.new "Missing argument: #{credential}." if value.blank?
          raise InvalidArgumentsError.new "Invalid #{credential} specified: #{value.inspect} must be a string or symbol." unless value.is_a?(String) || value.is_a?(Symbol)
        end
      end

      def validate_host_url!
        raise MissingArgumentsError.new 'Missing argument: host_url.' if @config[:host].blank?
        raise InvalidArgumentsError.new 'host_url does not specify a valid protocol (http/https).' unless @config[:host].start_with?('http://', 'https://')
      end

    end
  end
end
