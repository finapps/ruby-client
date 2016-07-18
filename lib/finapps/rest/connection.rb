module FinApps
  module REST
    module Connection # :nodoc:
      # @return [Faraday::Connection]
      def faraday(config, logger)
        options = {
          url: "#{config.host}/v#{Defaults::API_VERSION}/",
          request: {open_timeout: config.timeout,
                    timeout: config.timeout}
        }

        Faraday.new(options) do |conn|
          conn.request :accept_json
          conn.request :user_agent
          conn.request :tenant_authentication, config.tenant_identifier, config.tenant_token
          conn.request :json
          conn.request :retry
          conn.request :multipart
          conn.request :url_encoded
          conn.request :basic_auth, config.user_identifier, config.user_token if config.valid_user_credentials?

          conn.use FinApps::Middleware::RaiseError
          conn.response :rashify
          conn.response :json, content_type: /\bjson$/
          conn.response :logger, logger, bodies: true

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end
      end
      module_function :faraday # becomes available as a *private instance method* to classes that mix in the module
    end
  end
end
