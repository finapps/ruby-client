module FinApps
  module Middleware
    class RaiseError < Faraday::Response::Middleware # :nodoc:
      include FinApps::Utils::Loggeable

      CLIENT_ERROR_STATUSES = 400...600

      def on_complete(env)
        case env[:status]
        when 407
          # mimic the behavior that we get with proxy requests with HTTPS
          raise Faraday::Error::ConnectionFailed, '407 "Proxy Authentication Required"'
        when CLIENT_ERROR_STATUSES
          raise Faraday::Error::ClientError, response_values(env)
        else
          # 200..206 Success codes
          # all good!
          logger.debug "##{__method__} => Status code: [#{env[:status]}]"
        end
      end

      def response_values(env)
        {
          status:         env.status,
          headers:        env.response_headers,
          body:           env.body,
          error_messages: error_messages(env.body)
        }
      end

      private

      def error_messages(body)
        return nil unless body.present?
        body = parse_string(body) if body.is_a?(String)
        body.is_a?(Hash) ? body['messages'].presence : nil
      end

      def parse_string(body)
        ::JSON.parse(body)
      rescue ::JSON::ParserError
        logger.error "##{__method__} => Unable to parse JSON response."
      end
    end
  end
end
