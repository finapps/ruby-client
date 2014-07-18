module FinApps
  module REST

    class Users < FinApps::REST::Resources
      include FinApps::Logging
      include FinApps::REST::Defaults

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def create(params = {})
        logger.debug "##{__method__.to_s} => Started"
        user, error_messages = @client.post(END_POINTS[:users_create], params) { |r| User.new(r.body) }
        logger.debug "##{__method__.to_s} => Completed"

        return user, error_messages
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def login(params = {})
        logger.debug "##{__method__.to_s} => Started"
        user, error_messages = @client.post(END_POINTS[:users_login], params) { |r| User.new(r.body) }
        logger.debug "##{__method__.to_s} => Completed"

        return user, error_messages
      end

      # @param [String] public_id
      # @return [Array<String>]
      def delete(public_id)
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        _, error_messages = @client.delete(END_POINTS[:users_delete].sub! ':public_id', public_id.to_s)
        logger.debug "##{__method__.to_s} => Completed"

        error_messages
      end

    end

    class User < FinApps::REST::Resource
      attr_accessor :public_id, :token, :email, :first_name, :last_name, :postal_code
    end

  end
end