module FinApps
  module REST

    class Users < FinApps::REST::Resources

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def create(params = {})
        @logger.debug 'FinApps::REST::Users#create => Started'
        user, error_messages = @client.post(END_POINTS[:users_create], params) { |r| User.new(r.body) }
        @logger.debug 'FinApps::REST::Users#create => Completed'

        return user, error_messages
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array<String>]
      def login(params = {})
        @logger.debug 'FinApps::REST::Users#login => Started'

        user, error_messages = @client.post(END_POINTS[:users_login], params) { |r| User.new(r.body) }

        @logger.debug 'FinApps::REST::Users#login => Completed'
        return user, error_messages
      end

      # @param [String] public_id
      # @return [Array<String>]
      def delete(public_id)
        @logger.debug 'FinApps::REST::Users#delete => Started'

        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?

        path = END_POINTS[:users_delete].sub! ':public_id', public_id.to_s
        _, error_messages = @client.delete(path, {})

        @logger.debug 'FinApps::REST::Users#delete => Completed'
        error_messages
      end

    end

    class User < FinApps::REST::Resource
      attr_accessor :public_id, :token, :email, :first_name, :last_name, :postal_code
    end

  end
end