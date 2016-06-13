require 'pp'

module FinApps
  module REST
    module Connection
      include FinApps::REST::Defaults

      # @param [Hash] company_credentials
      # @param [Hash] config
      # @return [Faraday::Connection]
      def set_up_connection(company_credentials, config)
        host_url = config[:host].blank? ? DEFAULTS[:host] : config[:host]
        raise InvalidArgumentsError.new "Invalid argument: host_url: #{host_url}" unless host_url.start_with?('http://', 'https://')

        base_url = "#{host_url}/v#{API_VERSION}"
        timeout = config[:timeout].blank? ? DEFAULTS[:timeout] : config[:timeout]

        Faraday.new(:url => base_url,
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
      end

    end
  end
end