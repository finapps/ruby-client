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
        raise InvalidArgumentsError.new 'Invalid argument: client.' unless client.is_a?(FinApps::REST::Client)
        @client = client
      end

      def create(params={}, path=nil)
        path = end_point if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path} params: #{params}"
        results, error_messages = client.send_request(path, :post, params)
        [results, error_messages]
      end

      def update(params={}, path=nil)
        path = end_point if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path} params: #{params}"
        results, error_messages = client.send_request(path, :put, params)
        [results, error_messages]
      end

      def show(id, path=nil)
        path = "#{end_point}/:id".sub ':id', ERB::Util.url_encode(id) if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path}"
        results, error_messages = client.send_request(path, :get)
        [results, error_messages]
      end

      def destroy(id, path=nil)
        path = "#{end_point}/:id".sub ':id', ERB::Util.url_encode(id) if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path}"
        results, error_messages = client.send_request(path, :delete)
        [results, error_messages]
      end

      private

      def logger
        client.logger
      end

      def end_point
        self.class.name.split('::').last.downcase
      end
    end
  end
end
