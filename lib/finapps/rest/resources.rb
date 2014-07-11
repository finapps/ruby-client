module FinApps
  module REST
    class Resources
      include FinApps::REST::Defaults
      include FinApps::Logging

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
        logger.debug "##{__method__.to_s} => #{self.class.name} initialized."
      end

    end
  end
end