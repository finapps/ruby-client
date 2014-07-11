module FinApps
  module REST

    class Users < FinApps::REST::Resources
      include FinApps::Logging

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
<<<<<<< HEAD
=======

>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
        user, error_messages = @client.post(END_POINTS[:users_login], params) { |r| User.new(r.body) }
        logger.debug "##{__method__.to_s} => Completed"

<<<<<<< HEAD
=======
        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
        return user, error_messages
      end

      # @param [String] public_id
      # @return [Array<String>]
      def delete(public_id)
        logger.debug "##{__method__.to_s} => Started"
<<<<<<< HEAD
=======

>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        _, error_messages = @client.delete(END_POINTS[:users_delete].sub! ':public_id', public_id.to_s)
        logger.debug "##{__method__.to_s} => Completed"

<<<<<<< HEAD
=======
        path = END_POINTS[:users_delete].sub! ':public_id', public_id.to_s
        _, error_messages = @client.delete(path, {})

        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
        error_messages
      end

    end

    class User < FinApps::REST::Resource
      attr_accessor :public_id, :token, :email, :first_name, :last_name, :postal_code
    end

  end
end