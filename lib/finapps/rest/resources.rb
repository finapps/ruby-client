module FinApps
  module REST
    class Resources # :nodoc:
      attr_reader :client

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Resources]
      def initialize(client)
        @client = client
      end

      def create(params, endpoint)
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = Defaults::END_POINTS[endpoint]
        logger.debug "#{name}##{__method__} => path: #{path} params: #{params}"

        results, error_messages = client.send_request(path, :post, params)
        [results, error_messages]
      end
    end
  end
end
