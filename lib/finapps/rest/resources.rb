module FinApps
  module REST
    class Resources

      include FinApps::REST::Defaults
      include FinApps::Logging

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
      end

    end
  end
end