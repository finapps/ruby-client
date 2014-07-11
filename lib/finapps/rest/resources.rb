module FinApps
  module REST
    class Resources
      include FinApps::REST::Defaults
      include FinApps::Logging

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
<<<<<<< HEAD
        logger.debug "##{__method__.to_s} => #{self.class.name} initialized."
=======
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

>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
      end

    end
  end
end