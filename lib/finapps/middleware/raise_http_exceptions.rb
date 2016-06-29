module FinApps
  module Middleware
    class RaiseHttpExceptions < Faraday::Response::Middleware # :nodoc:
      include FinApps::Utils::Loggeable

      def initialize(app)
        super app
        @parser = nil
      end

      def call(env)
        @app.call(env).on_complete do |response|
          case response[:status].to_i
          when 400
            raise FinApps::Errors::BadRequest, error_message_400(response)
          when 404
            raise FinApps::REST::NotFound, error_message_400(response)
          when 409
            raise FinApps::REST::Conflict, error_message_400(response)

          when 500
            raise FinApps::REST::InternalServerError,
                  error_message_500(response, 'Unexpected technical condition was encountered.')
          when 502
            raise FinApps::REST::BadGateway,
                  error_message_500(response, 'The server returned an invalid or incomplete response.')
          when 504
            raise FinApps::REST::GatewayTimeout,
                  error_message_500(response, 'Gateway Time-out.')
          end
        end
      end

      private

      def error_message_400(response)
        "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]}#{error_body(response[:body])}"
      end

      def error_body(body)
        body = parse_json(body) if body.present? && body.is_a?(String)

        if body.nil?
          nil
        elsif body['error_message'] && body['error_message'].present?
          ": #{body['error_type']}: #{body['error_message']}"
        end
      end

      def parse_json(body)
        ::JSON.parse(body)
      rescue ::JSON::ParserError
        logger.error "##{__method__} => Unable to parse JSON response."
      end

      def error_message_500(response, body=nil)
        "#{response[:method].to_s.upcase} #{response[:url]}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
      end
    end
  end
end
