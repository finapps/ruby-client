require 'pp'

module FinApps
  module REST
    module Connection
      include FinApps::REST::Defaults

      # @param [Hash] company_credentials
      # @param [Hash] config
      # @return [Faraday::Connection]
      def set_up_connection(company_credentials, config)
        company_credentials.validate_required_strings!
        logger.debug "##{__method__.to_s} => company_credentials were provided."

        host = config[:host]
        validate_host_url! host

        base_url = "#{host}/v#{API_VERSION}"
        logger.debug " base_url: #{base_url}"

        timeout = config[:timeout].blank? ? DEFAULTS[:timeout] : config[:timeout]
        logger.debug " timeout: #{timeout}"

        Faraday.new(:url => base_url,
                    :request => {
                        :open_timeout => timeout,
                        :timeout => timeout},
                    :headers => {
                        :accept => HEADERS[:accept],
                        :user_agent => HEADERS[:user_agent]}) do |conn|

          set_request_middleware(conn, company_credentials)
          set_basic_authentication(conn, config)
          set_response_middleware(conn)

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end
      end

      private
      def set_response_middleware(conn)
        conn.use FinApps::Middleware::RaiseHttpExceptions
        conn.response :rashify
        conn.response :json, :content_type => /\bjson$/
        conn.use FinApps::Middleware::ResponseLogger
      end

      def set_request_middleware(conn, company_credentials)
        conn.use FinApps::Middleware::ApiToken, company_credentials
        conn.request :json
        conn.request :retry
        conn.request :multipart
        conn.request :url_encoded
      end

      def set_basic_authentication(conn, config)
        if config[:user_identifier].blank? || config[:user_token].blank?
          logger.debug "##{__method__.to_s} => User credentials were not provided. Authentication header not set."
        else
          conn.request :basic_auth, config[:user_identifier], config[:user_token]
          logger.debug "##{__method__.to_s} => Basic Authentication header set for provided user credentials."
        end
      end

      def validate_host_url!(host_url)
        raise MissingArgumentsError.new 'Missing argument: host_url.' if host_url.blank?
        raise InvalidArgumentsError.new 'Invalid argument: host_url does not specify a valid protocol (http/https).' unless host_url.start_with?('http://', 'https://')

        logger.debug "##{__method__.to_s} => host [#{host_url}] passed validation."
      end

    end
  end
end