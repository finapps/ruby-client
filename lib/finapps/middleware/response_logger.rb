module FinApps
  module Middleware

    class ResponseLogger < Faraday::Response::Middleware
      include FinApps::Logging

      def call(env)
        logger.info "##{env.method} #{env.url.to_s}"
        logger.debug('Request Headers') { dump_headers env.request_headers }
        super
      end

      def on_complete(env)
        logger.info "Status: #{env.status.to_s}"
        logger.debug('Response Headers') { dump_headers env.response_headers }
        logger.debug('Response Body') {dump_body env.body } if env.body
      end

      private
      def dump_headers(headers)
        "\n" << headers.map { |k, v| "  #{k}: #{filter_sensitive_header_values(k,v)}" }.join("\n")
      end

      def filter_sensitive_header_values(key, value)
        case key
          when 'X-FinApps-Token', 'Authorization'
            '[REDACTED]'
          else
            value.inspect
        end
      end

      def dump_body(body)
        "\n" << body
      end

    end

  end
end
