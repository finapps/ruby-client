module FinApps
  module REST
    class Resources

      include FinApps::REST::Defaults
      include FinApps::Logging

      attr_reader :client

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
      end

    end
  end
end