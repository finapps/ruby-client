module FinApps
  module REST
    class Resources
      include FinApps::REST::Defaults

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
        # @logger = client.logger || begin
        #   require 'logger' unless defined?(::Logger)
        #   ::Logger.new(STDOUT).tap do |log|
        #     # noinspection SpellCheckingInspection
        #     log.progname = self.class.name
        #     log.debug '#initialize => Logger instance created'
        #   end
        #
        #   @logger.debug "#{self.class.name}#initialize => Initialized."
        # end

      end
    end
  end
end