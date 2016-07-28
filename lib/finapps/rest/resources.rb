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
        request_with_body(path, :post, params)
      end

      def update(params={}, path=nil)
        request_with_body(path, :put, params)
      end

      def show(id=nil, path=nil)
        request_without_body(path, :get, id)
      end

      def destroy(id=nil, path=nil)
        request_without_body(path, :delete, id)
      end

      def request_without_body(path, method, id)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.nil? && path.nil?
        path = "#{end_point}/:id".sub ':id', ERB::Util.url_encode(id) if path.nil?
        request_with_body path, method, {}
      end

      def request_with_body(path, method, params)
        path = end_point if path.nil?
        logger.debug "#{self.class.name}##{__method__} => path: #{path} params: #{params}"

        client.send_request path, method, params
      end

      protected

      def logger
        client.logger
      end

      def end_point
        self.class.name.split('::').last.downcase
      end
    end
  end
end
