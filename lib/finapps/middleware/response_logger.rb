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
        "\n" << headers.map { |k, v| "  #{k}: #{v.inspect}" }.join("\n")
      end

      def dump_body(body)
        "\n" << body
      end

    end

  end
end
