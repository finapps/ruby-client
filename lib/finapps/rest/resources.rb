# frozen_string_literal: true
module FinApps
  module REST
    class Resources # :nodoc:
      require 'erb'

      attr_reader :client

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        raise MissingArgumentsError.new 'Missing argument: client.' if client.nil?
        @client = client
      end

      def create(params={}, path=nil)
        path = self.class.name.split('::').last.downcase if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path} params: #{params}"
        results, error_messages = client.send_request(path, :post, params)
        [results, error_messages]
      end

      def show(id, path=nil)
        if path.nil?
          path = "#{self.class.name.split('::').last.downcase}/:id".sub ':id', ERB::Util.url_encode(id)
        end
        logger.debug "#{self.class.name}##{__method__} => path: #{path}"
        results, error_messages = client.send_request(path, :get)
        [results, error_messages]
      end

      private

      def logger
        client.logger
      end
    end
  end
end
