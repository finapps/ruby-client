module FinApps
  module REST

    # Custom error class for rescuing from all FinApps errors
    class Error < StandardError;
      attr_reader :response

      def initialize(ex, response = nil)
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

      # @return [Array]
      def error_messages
        @response.present? ? @response[:error_messages] : []
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