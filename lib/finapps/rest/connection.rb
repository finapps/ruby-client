module FinApps
  module REST
    module Connection # :nodoc:
      RUBY = "#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".freeze

      # @return [Faraday::Connection]
      def faraday(config, logger)
        Faraday.new(url:     "#{config.host}/v#{Defaults::API_VERSION}/",
                    request: {open_timeout: config.timeout,
                              timeout: config.timeout},
                    headers: {accept: 'application/json',
                              user_agent: "finapps-ruby/#{FinApps::VERSION} (#{RUBY})"}) do |conn|
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
          conn.response :logger, logger, bodies: true

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end
      end
      module_function :faraday # becomes available as a *private instance method* to classes that mix in the module
    end
  end
end
