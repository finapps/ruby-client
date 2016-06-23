module FinApps
  module REST
    class Connection # :nodoc:
      # @param [Hash] tenant_credentials
      # @param [Hash] config
      # @return [Faraday::Connection]
      def initialize(config, logger = nil)


        Faraday.new(versioned_url: versioned_url(config),
                    request: {
                        open_timeout: config[:timeout],
                        timeout: config[:timeout]
                    },
                    headers: {
                        accept: HEADERS[:accept],
                        user_agent: HEADERS[:user_agent]
                    }) do |conn|
          # user level authentication
          conn.request :basic_auth, config[:user_identifier], config[:user_token] if authenticated?(config)

          # tenant level authentication
          conn.use FinApps::Middleware::TenantAuthentication, config[:tenant_credentials]

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

      private


    end

  end
end
