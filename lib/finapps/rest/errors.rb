module FinApps
  module REST
    # Custom error class for rescuing from all FinApps errors
    class Error < StandardError
      include ::FinApps::Utils::Loggeable
      attr_reader :response

      def initialize(ex, response=nil)
        @wrapped_exception = nil
        @response = response

        if ex.respond_to?(:backtrace)
          super(ex.message)
          @wrapped_exception = ex
        elsif ex.respond_to?(:each_key)
          super("the server responded with status #{ex[:status]}")
          @response = ex
        else
          super(ex.to_s)
        end
      end

      def backtrace
        if @wrapped_exception
          @wrapped_exception.backtrace
        else
          super
        end
      end

      def inspect
        %(#<#{self.class}>)
      end

      # @return [Array<String>]
      def error_messages
        parsed_body = parse_string_body(@response.key?(:body) ? @response[:body] : @response)
        extract_messages(parsed_body)
      end

      def extract_messages(body)
        parsed = nil
        if body.is_a?(Hash)
          # http://stackoverflow.com/questions/10780817/hash-with-indifferent-access
          body.default_proc = proc {|h, k| h.key?(k.to_s) ? h[k.to_s] : nil }
          # TODO: remove => API should be consistent, either :message or :error_message key should be used, not both
          body[:messages] = body.delete(:error_messages) if body.key?(:error_messages)
          parsed = body[:messages] if body.key?(:messages)
        end

        parsed.blank? ? [message] : parsed
      end

      def parse_string_body(body)
        parsed = nil
        begin
          parsed = ::JSON.parse(body)
          logger.info "##{__method__} => Cannot extract errors: unexpected error while parsing response." unless parsed
        rescue ::JSON::ParserError
          logger.error "##{__method__} => Unable to parse JSON response."
        end
        parsed
      end
    end

    # Raised when required arguments are missing
    class MissingArgumentsError < Error
      def initialize(message)
        super(message)
      end
    end

    # Raised when invalid arguments are detected
    class InvalidArgumentsError < Error
      def initialize(message)
        super(message)
      end
    end

    # Client Error 4xx
    # The 4xx class of status code is intended for cases in which the client seems to have erred.
    class ClientError < Error
    end

    class BadRequest < ClientError
    end

    class Unauthorized < ClientError
    end

    class Forbidden < ClientError
    end

    class NotFound < ClientError
    end

    class MethodNotAllowed < ClientError
    end

    class NotAcceptable < ClientError
    end

    class ConnectionFailed < ClientError
    end

    class Conflict < ClientError
    end

    # Server Error 5xx
    #
    # Response status codes beginning with the digit "5" indicate cases in which the server is aware
    # that it has erred or is incapable of performing the request.
    class ServerError < Error
    end

    class InternalServerError < ServerError
    end

    class BadGateway < ServerError
    end

    class ServiceUnavailable < ServerError
    end

    class GatewayTimeout < ServerError
    end

    class VersionNotSupported < ServerError
    end
  end
end
