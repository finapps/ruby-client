require 'pp'

module FinApps
  module REST
    module Connection
      include FinApps::REST::Defaults

      # @param [Hash] company_credentials
      # @param [Hash] config
      # @return [Faraday::Connection]
      def set_up_connection(company_credentials, config)
        logger.debug "##{__method__.to_s} => Started"

        company_credentials.validate_required_strings!
        logger.debug "##{__method__.to_s} => company_credentials passed validation."

        host = config[:host]
        validate_host_url! host

        base_url = "#{host}/v#{API_VERSION}"
        logger.debug " base_url: #{base_url}"

        timeout = config[:timeout].blank? ? DEFAULTS[:timeout] : config[:timeout]
        logger.debug " timeout: #{timeout}"

        user_identifier = config[:user_identifier]
        logger.debug " user_identifier: #{user_identifier}" if user_identifier.present?

        user_token = config[:user_token]
        logger.debug ' user_token: [REDACTED]' if user_token.present?

        connection = Faraday.new(:url => base_url,
                                 :request => {
                                     :open_timeout => timeout,
                                     :timeout => timeout},
                                 :headers => {
                                     :accept => HEADERS[:accept],
                                     :user_agent => HEADERS[:user_agent]}) do |conn|

          # Request Middleware
          conn.use FinApps::Middleware::ApiToken, company_credentials
          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
          if user_identifier.blank? || user_token.blank?
            logger.debug "##{__method__.to_s} => User credentials were not provided. Authentication header not set."
          else
            conn.request :basic_auth, user_identifier, user_token
            logger.debug "##{__method__.to_s} => Basic Authentication header set for provided user credentials."
          end

          # Response Middleware
          conn.use FinApps::Middleware::RaiseHttpExceptions
          conn.response :rashify
          conn.response :json, :content_type => /\bjson$/
          conn.use FinApps::Middleware::ResponseLogger

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end

        logger.debug "##{__method__.to_s} => Completed"
        connection
      end

      private
      def validate_host_url!(host_url)
        raise MissingArgumentsError.new 'Missing argument: host_url.' if host_url.blank?
        raise InvalidArgumentsError.new 'Invalid argument: host_url does not specify a valid protocol (http/https).' unless host_url.start_with?('http://', 'https://')

        logger.debug "##{__method__.to_s} => host [#{host_url}] passed validation."
      end

    end
  end
end