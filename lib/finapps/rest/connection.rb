module FinApps
  module REST
    module Connection
      include FinApps::REST::Defaults

      # @param [Hash] params
      def set_up_connection(params = {})
        logger.debug 'FinApps::REST::Connection#set_up_connection =>  Started'

        company_credentials = {:company_identifier => params[:company_identifier],
                               :company_token => params[:company_token]}
        validate_company_credentials!(company_credentials)

        config = params[:config]

        host = config[:host]
        validate_host_url! host

        base_url = "#{host}/v#{API_VERSION}"
        logger.debug "FinApps::REST::Connection#set_up_connection => base_url: #{base_url}"

        timeout = config[:timeout].blank? ? DEFAULTS[:timeout] : config[:timeout]
        logger.debug "FinApps::REST::Connection#set_up_connection => timeout: #{timeout}"

        user_identifier = config[:user_identifier]
        logger.debug "FinApps::REST::Connection#set_up_connection => user_identifier: #{user_identifier.blank? ? 'nil' : user_identifier}"

        user_token = config[:user_token]
        logger.debug "FinApps::REST::Connection#set_up_connection => user_token: #{user_token.blank? ? 'nil' : user_token}"

        connection = Faraday.new(:url => base_url,
                                  :request => {
                                      :open_timeout => timeout,
                                      :timeout => timeout},
                                  :headers => {
                                      :accept => HEADERS[:accept],
                                      :user_agent => HEADERS[:user_agent]}) do |conn|

          # Request Middleware
          conn.use FinApps::Middleware::ApiToken, company_credentials, logger
          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
          if user_identifier.blank? || user_token.blank?
            logger.debug 'FinApps::REST::Connection#set_up_connection => Authentication header not set.'
          else
            conn.request :basic_auth, user_identifier, user_token
            logger.debug "FinApps::REST::Connection#set_up_connection => Authentication header set for user identifier: #{user_identifier}"
          end

          # Response Middleware
          conn.use FinApps::Middleware::RaiseHttpExceptions, logger
          conn.response :rashify
          conn.response :json, :content_type => /\bjson$/
          conn.response :logger, logger

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end

        logger.debug 'FinApps::REST::Connection#set_up_connection => Completed'
        connection
      end

      private
      def validate_company_credentials!(company_credentials)
        company_credentials.each do |credential, value|
          raise MissingArgumentsError.new "Missing argument: #{credential}." if value.blank?
          raise InvalidArgumentsError.new "Invalid #{credential} specified: #{value.inspect} must be a string or symbol." unless value.is_a?(String) || value.is_a?(Symbol)
        end

        logger.debug "FinApps::REST::Connection#validate_company_credentials! =>  company_credentials: #{company_credentials}"
      end

      def validate_host_url!(host_url)
        raise MissingArgumentsError.new 'Missing argument: host_url.' if host_url.blank?
        raise InvalidArgumentsError.new 'host_url does not specify a valid protocol (http/https).' unless host_url.start_with?('http://', 'https://')

        logger.debug "FinApps::REST::Connection#validate_host_url! => #{host_url} is a valid host url."
      end

    end
  end
end