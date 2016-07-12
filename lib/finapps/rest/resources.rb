module FinApps
  module REST
    class Resources # :nodoc:
      require 'erb'

      attr_reader :client

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        raise MissingArgumentsError.new 'Missing argument: client.' if client.blank?
        @client = client
      end

      def create(params={}, path=nil)
        path = end_points[:create] if path.nil?
        logger.debug "#{name}##{__method__} => path: #{path} params: #{params}"

        results, error_messages = client.send_request(path, :post, params)
        [results, error_messages]
      end

      protected

      def end_points
        {
          list:    self.class.name.downcase,
          create:  "#{self.class.name.downcase}/new",
          show:    "#{self.class.name.downcase}/:id",
          update:  "#{self.class.name.downcase}/:id",
          destroy: "#{self.class.name.downcase}/:id"
        }
      end

      private

      def logger
        client.logger
      end
    end
  end
end
