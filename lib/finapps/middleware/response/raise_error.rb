# frozen_string_literal: true
module FinApps
  module Middleware
    class RaiseError < Faraday::Response::Middleware # :nodoc:
      using ObjectExtensions
      using StringExtensions

      SUCCESS_STATUSES = 200..299
      CONNECTION_FAILED_STATUS = 407

      def on_complete(env)
        if SUCCESS_STATUSES.include? env[:status]
          # do nothing
        elsif env[:status] == CONNECTION_FAILED_STATUS
          raise(Faraday::Error::ConnectionFailed, '407 "Proxy Authentication Required"')
        else
          raise(Faraday::Error::ClientError, response_values(env))
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
        return nil if body.blank?
        body = parse_string(body) if body.is_a?(String)
        has_message_key?(body) ? body['messages'] : nil
      end

      def has_message_key?(body)
        body.respond_to?(:key?) && body.key?('messages')
      end

      def parse_string(body)
        ::JSON.parse(body)
      rescue ::JSON::ParserError
        # logger.error "##{__method__} => Unable to parse JSON response."
      end
    end
  end
end
