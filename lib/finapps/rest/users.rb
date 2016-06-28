module FinApps
  module REST
    class Users < FinApps::REST::Resources # :nodoc:
      require 'erb'
      include FinApps::REST::Defaults

      # @param [String] public_id
      # @return [FinApps::REST::User, Array<String>]
      def show(public_id)
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        logger.debug "##{__method__} => public_id: #{public_id}"

        end_point = Defaults::END_POINTS[:users_show]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point.sub ':public_id', ERB::Util.url_encode(public_id)
        logger.debug "##{__method__} => path: #{path}"

        user, error_messages = client.send_request(path, :get) {|r| User.new(r.body) }
        [user, error_messages]
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def create(params={})
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__} => params: #{skip_sensitive_data params}"

        end_point = Defaults::END_POINTS[:users_create]
        logger.debug "##{__method__} => end_point: #{end_point}"

        user, error_messages = client.send_request(end_point, :post, params) {|r| User.new(r.body) }
        [user, error_messages]
      end

      # @param [Hash] params
      # @return [Array<String>]
      def update(params={})
        logger.debug "##{__method__} => params: #{skip_sensitive_data params}"

        path = Defaults::END_POINTS[:users_update]
        logger.debug "##{__method__} => path: #{path}"

        _, error_messages = client.send_request(path, :put, params.compact)
        error_messages
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def update_password(params={})
        logger.debug "##{__method__} => params: #{skip_sensitive_data params}"

        path = Defaults::END_POINTS[:users_update_password]
        logger.debug "##{__method__} => path: #{path}"

        user, error_messages = client.send_request(path, :put, params.compact) {|r| User.new(r.body) }
        [user, error_messages]
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def login(params={})
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__} => params: #{skip_sensitive_data params}"

        end_point = Defaults::END_POINTS[:users_login]
        logger.debug "##{__method__} => end_point: #{end_point}"

        user, error_messages = client.send_request(end_point, :post, params) {|r| User.new(r.body) }
        [user, error_messages]
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

        _, error_messages = client.send_request(path, :delete)
        error_messages
      end
    end

    class User < FinApps::REST::Resource # :nodoc:
      attr_accessor :public_id, :token, :email, :first_name, :last_name, :postal_code
    end
  end
end
