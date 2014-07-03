module FinApps
  module REST

    class Users
      include FinApps::REST::Defaults

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Users]
      def initialize(client)
        @client = client
        @logger = client.logger
        @logger.debug 'FinApps::REST::Users => initialized'
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array]
      def create(params = {})
        @logger.debug 'FinApps::REST::Users#create => Started'
        user, error_messages = @client.post(END_POINTS[:users_create], params){|r| User.new(r.body)}
        @logger.debug 'FinApps::REST::Users#create => Completed'

        return user, error_messages
      end

      # @param [Hash] params
      # @return [FinApps::REST::User]
      def login(params = {})
        @logger.debug 'FinApps::REST::Users#login => Started'
        user, error_messages = @client.post(END_POINTS[:users_login], params){|r| User.new(r.body)}
        @logger.debug 'FinApps::REST::Users#login => Completed'

        return user, error_messages
      end


    end

    class User < FinApps::REST::Base
      attr_accessor :public_id, :token, :email, :first_name, :last_name, :postal_code
    end

  end
end