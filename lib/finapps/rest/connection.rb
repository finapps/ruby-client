module FinApps
  module REST
    module Connection # :nodoc:
      module_function

      def faraday(config, logger)
        Faraday.new(config.connection_options) do |conn|
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
          conn.use FinApps::Middleware::RaiseError
          conn.response :rashify
          conn.response :json, content_type: /\bjson$/
          conn.response :logger, logger # , bodies: true

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end
      end
    end
  end
end
