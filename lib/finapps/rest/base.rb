module FinApps
  module REST
    class Base

      attr_reader :error_messages

      def initialize(error_messages)
        @error_messages = error_messages || Array.new
      end

      def is_valid?
        @error_messages.empty?
      end

    end

  end
end