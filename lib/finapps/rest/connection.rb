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

        host = config[:host]
        validate_host_url! host

        base_url = "#{host}/v#{API_VERSION}"
        timeout = config[:timeout].blank? ? DEFAULTS[:timeout] : config[:timeout]


        connection = Faraday.new(:url => base_url,
                                 :request => {
                                     :open_timeout => timeout,
                                     :timeout => timeout},
                                 :headers => {
                                     :accept => HEADERS[:accept],
                                     :user_agent => HEADERS[:user_agent]}) do |conn|

          # add basic authentication header if user credentials were provided
          user_identifier = config[:user_identifier]
          user_token = config[:user_token]
          conn.request :basic_auth, user_identifier, user_token unless user_identifier.blank? || user_token.blank?

          # company level authentication
          conn.use FinApps::Middleware::ApiToken, company_credentials

          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
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
