module FinApps
  module REST
    class Users < FinApps::REST::Resources # :nodoc:
      require 'erb'
      include FinApps::REST::Defaults

      # @param [String] public_id
      # @return [FinApps::REST::User, Array<String>]
      def show(public_id)
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?

        end_point = Defaults::END_POINTS[:users_show]
        path = end_point.sub ':public_id', ERB::Util.url_encode(public_id)

        logger.debug "##{__method__} => path: #{path}"

        results, error_messages = client.send_request(path, :get)
        [results, error_messages]
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def create(params)
        super(params, :users_create)
      end

      # @param [Hash] params
      # @return [Array<String>]
      def update(params)
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__} => params: #{params}"

        end_point = Defaults::END_POINTS[:users_update]
        path = end_point

        logger.debug "##{__method__} => path: #{path}"

        results, error_messages = client.send_request(path, :put, params.compact)
        [results, error_messages]
      end

      # @param [String] public_id
      # @return [Array<String>]
      def delete(public_id)
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        logger.debug "##{__method__} => public_id: #{public_id}"

        end_point = Defaults::END_POINTS[:users_delete]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point.sub ':public_id', ERB::Util.url_encode(public_id)
        logger.debug "##{__method__} => path: #{path}"

        results, error_messages = client.send_request(path, :delete)
        [results, error_messages]
      end
    end
  end
end
