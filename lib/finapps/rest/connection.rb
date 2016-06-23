module FinApps
  module REST
    module Connection

      # @param [Hash] tenant_credentials
      # @param [Hash] config
      # @return [Faraday::Connection]
      def set_up_connection(config)

        raise FinApps::REST::InvalidArgumentsError.new 'Invalid tenant credentials.' unless
            valid_tenant_credentials?(config[:tenant_credentials])

        config[:host] = FinApps::REST::Defaults::DEFAULTS[:host] if config[:host].blank?
        unless valid_host?(config)
          raise InvalidArgumentsError.new "Invalid argument. {host: #{config[:host]}}"
        end

        config[:timeout] = FinApps::REST::Defaults::DEFAULTS[:timeout] if config[:timeout].blank?
        unless valid_timeout?(config)
          raise InvalidArgumentsError.new "Invalid argument. {timeout: #{config[:timeout]}}"
        end

        Faraday.new(:url => "#{config[:host]}/v#{FinApps::REST::Defaults::API_VERSION}",
                    :request => {
                        :open_timeout => config[:timeout],
                        :timeout => config[:timeout]},
                    :headers => {
                        :accept => HEADERS[:accept],
                        :user_agent => HEADERS[:user_agent]}) do |conn|

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
          conn.response :json, :content_type => /\bjson$/
          conn.response :logger, Rails.logger||= ::Logger.new(STDOUT), bodies: true

          # Adapter (ensure that the adapter is always last.)
          conn.adapter :typhoeus
        end
      end

      private

      def authenticated?(config)
        config[:user_identifier].present? && config[:user_token].present?
      end

      def valid_host?(config)
        config[:host].start_with?('http://', 'https://')
      end

      def valid_timeout?(config)
        Integer(config[:timeout]) rescue false
      end

    end
  end
end