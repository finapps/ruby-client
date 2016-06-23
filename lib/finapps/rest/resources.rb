module FinApps
  module REST
    class Resources
      attr_reader :client

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
      end

    end
  end
end