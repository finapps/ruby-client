module FinApps
  module Middleware

    class RaiseHttpExceptions < Faraday::Response::Middleware

      CLIENT_ERROR_STATUSES = 400...600

      def initialize(app, logger = nil)
        super(app)
        @logger = logger || begin
          require 'logger'
          ::Logger.new(STDOUT).tap do |log|
            # noinspection SpellCheckingInspection
            log.progname = 'FinApps::Middleware::RaiseHttpExceptions'
            log.debug '#initialize => Logger instance created'
          end
        end
      end

      def on_complete(env)

        case env[:status]
          when 400
            raise FinApps::REST::BadRequest, response_values(env, 'The request could not be understood by the server due to malformed syntax.')
          when 401
            raise FinApps::REST::Unauthorized, response_values(env, 'The request requires user authentication.')
          when 403
            raise FinApps::REST::Forbidden, response_values(env, 'Forbidden.')
          when 404
            raise FinApps::REST::NotFound, response_values(env, 'Page not found.')
          when 405
            raise FinApps::REST::MethodNotAllowed, response_values(env, 'The method specified in the Request-Line is not allowed for the resource identified by the Request-URI.')
          when 406
            raise FinApps::REST::NotAcceptable, response_values(env, 'The resource identified by the request is only capable of generating response entities which have content characteristics not acceptable according to the accept headers sent in the request')
          when 407
            raise Faraday::Error::ConnectionFailed, response_values(env, 'Proxy Authentication Required.')
          when 409
            raise FinApps::REST::Conflict, response_values(env, 'The request could not be completed due to a conflict with the current state of the resource.')

          when 500
            raise FinApps::REST::InternalServerError, response_values(env, 'Unexpected technical condition was encountered.')
          when 502
            raise FinApps::REST::BadGateway, response_values(env, 'The server returned an invalid or incomplete response.')
          when 503
            raise FinApps::REST::ServiceUnavailable, response_values(env, 'The server is currently unavailable.')
          when 504
            raise FinApps::REST::GatewayTimeout, response_values(env, 'Gateway Time-out')
          when 505
            raise FinApps::REST::VersionNotSupported, response_values(env, 'The Web server does not support the specified HTTP protocol version.')

          when CLIENT_ERROR_STATUSES
            raise FinApps::REST::Error, response_values(env, 'Unexpected error.')

          else
            # 200..206 Success codes
            # all good!
        end

      end

      private

      def error_messages(body)
        error_array = Array.new

        if body.present? && body.kind_of?(String)
          begin
            parsed = ::JSON.parse(body)
            if parsed
              parsed.each do |key, value|
                value.each do |message|
                  @logger.debug "#{key} => #{message}"
                  error_array.push message.to_s
                end
              end
            else
              @logger.info 'Cannot extract errors: response does not contain valid JSON.'
            end
          rescue ::JSON::ParserError => e
            @logger.error 'Cannot extract errors: unexpected error while parsing response.'
            @logger.error e.message
          end
        end

        error_array
      end

      def response_values(env, status_message = nil)
        {
            :status => env.status,
            :status_message => status_message,
            :headers => env.response_headers,
            :body => env.body,
            :error_messages => error_messages(env.body)
        }
      end

    end

  end
end