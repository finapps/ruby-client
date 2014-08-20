module FinApps
  module REST

    require 'erb'

    class Users < FinApps::REST::Resources
      include FinApps::Logging
      include FinApps::REST::Defaults

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def create(params = {})
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        end_point = Defaults::END_POINTS[:users_create]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        user, error_messages = @client.send(end_point, :post, params) { |r| User.new(r.body) }
        logger.debug "##{__method__.to_s} => Completed"

        return user, error_messages
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def login(params = {})
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        end_point = Defaults::END_POINTS[:users_login]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        user, error_messages = @client.send(end_point, :post, params) { |r| User.new(r.body) }
        logger.debug "##{__method__.to_s} => Completed"

        return user, error_messages
      end

      # @param [String] public_id
      # @return [Array<String>]
      def delete(public_id)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        logger.debug "##{__method__.to_s} => public_id: #{public_id}"

        end_point = Defaults::END_POINTS[:users_delete]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':public_id', ERB::Util.url_encode(public_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        _, error_messages = @client.send(path, :delete)
        logger.debug "##{__method__.to_s} => Completed"

        error_messages
      end

    end

    class User < FinApps::REST::Resource
      attr_accessor :public_id, :token, :email, :first_name, :last_name, :postal_code
    end

  end
end