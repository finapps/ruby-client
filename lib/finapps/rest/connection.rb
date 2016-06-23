module FinApps
  module REST
    class Connection # :nodoc:
      # @param [Hash] tenant_credentials
      # @param [Hash] options
      # @return [Faraday::Connection]
      def initialize(options, logger=nil)
        config = FinApps::REST::Configuration.new options

        Faraday.new(faraday_options(config)) do |conn|
          # tenant level authentication
          conn.use FinApps::Middleware::TenantAuthentication, config[:tenant_credentials]

          # user level authentication
          conn.request :basic_auth, config.user_credentials[:identifier], config.user_credentials[:token] if
              config.valid_user_credentials?

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

      def faraday_options(config)
        {host:    config.versioned_url,
         request: {open_timeout: config.timeout, timeout: config.timeout},
         headers: {accept: HEADERS[:accept], user_agent: HEADERS[:user_agent]}}
      end
    end
  end
end
