module FinApps
  module Middleware

    class ResponseLogger < Faraday::Response::Middleware
      include FinApps::Logging

      def call(env)
        logger.info "##{__method__.to_s} => ##{env.method} #{env.url.to_s}"
        logger.debug "##{__method__.to_s} => Request Headers: #{dump_headers env.request_headers}"

        super
      end

      def on_complete(env)
        logger.info "##{__method__.to_s} => ##{env.method} #{env.url.to_s}"
        logger.debug "##{__method__.to_s} => Response Headers: #{dump_headers env.response_headers}"
        logger.info "##{__method__.to_s} => Response Body: #{env.body}" if env.body
      end

      private
      def dump_headers(headers)
        headers.map { |k, v| "  #{k}: #{filter_sensitive_header_values(k,v)}" }.to_s
      end

      def filter_sensitive_header_values(key, value)
        case key
          when 'X-FinApps-Token', 'Authorization'
            '[REDACTED]'
          else
            value.inspect
        end
      end

    end

  end
end
