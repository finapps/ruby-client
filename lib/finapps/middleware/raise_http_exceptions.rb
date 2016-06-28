module FinApps
  module Middleware
    class RaiseHttpExceptions < Faraday::Response::Middleware # :nodoc:
      include FinApps::Utils::Loggeable

      CLIENT_ERROR_STATUSES = 400...600

      API_ERROR_STATUSES = {
        400 => {error:   FinApps::REST::BadRequest,
                message: 'The request could not be understood by the server due to malformed syntax.'},
        401 => {error:   FinApps::REST::Unauthorized,
                message: 'The request requires user authentication.'},
        403 => {error:   FinApps::REST::Forbidden,
                message: 'Forbidden.'},
        404 => {error:   FinApps::REST::NotFound,
                message: 'Page not found.'},
        405 => {error:   FinApps::REST::MethodNotAllowed,
                message: 'The method specified is not allowed for the resource.'},
        406 => {error:   FinApps::REST::NotAcceptable,
                message: 'Not acceptable according to the accept headers sent in the request.'},
        407 => {error:   FinApps::REST::ConnectionFailed,
                message: 'Proxy Authentication Required.'},
        409 => {error:   FinApps::REST::Conflict,
                message: 'The request could not be completed due to a conflict.'},

        500 => {error:   FinApps::REST::InternalServerError,
                message: 'Unexpected technical condition was encountered.'},
        502 => {error:   FinApps::REST::BadGateway,
                message: 'The server returned an invalid or incomplete response.'},
        503 => {error:   FinApps::REST::ServiceUnavailable,
                message: 'The server is currently unavailable.'},
        504 => {error:   FinApps::REST::GatewayTimeout,
                message: 'Gateway Time-out.'},
        505 => {error:   FinApps::REST::VersionNotSupported,
                message: 'The Web server does not support the specified HTTP protocol version.'}

      }.freeze

      def on_complete(env)
        case env[:status]
        when API_ERROR_STATUSES.keys
          raise API_ERROR_STATUSES[env[:status]][:error], messages(env, API_ERROR_STATUSES[env[:status]][:message])

        when CLIENT_ERROR_STATUSES
          raise FinApps::REST::Error, messages(env, "Unexpected error. Status: #{env.status}")

        else
          # 200..206 Success codes
          # all good!
          logger.debug "##{__method__} => Status code: [#{env[:status]}]."
        end
      end

      private

      def messages(env, custom_message)
        return {error_messages: []} unless env.body.present?

        error_array = []
        begin
          parsed = ::JSON.parse(env.body)
          if parsed && parsed.respond_to?(:each)
            parsed.each {|_key, value| value.each {|message| error_array << (custom_message || message).to_s } }
          end
        rescue ::JSON::ParserError
          logger.error "##{__method__} => Unable to parse JSON response."
        end

        {error_messages: error_array}
      end
    end
  end
end
