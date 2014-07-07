module FinApps
  module REST
    class Resources
      include FinApps::REST::Defaults

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
        @logger = client.logger
        @logger.debug "#{self.class.name}#initialize => Initialized."
      end

    end
  end
end