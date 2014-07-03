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
        user, error_messages = post(END_POINTS[:users_create], params)
        @logger.debug 'FinApps::REST::Users#create => Completed'

        return user, error_messages
      end

      # @param [Hash] params
      # @return [FinApps::REST::User]
      def login(params = {})
        @logger.debug 'FinApps::REST::Users#login => Started'
        user, error_messages = post(END_POINTS[:users_login], params)
        @logger.debug 'FinApps::REST::Users#login => Completed'

        return user, error_messages
      end

      private

      def post(end_point, params={})
        @logger.debug 'FinApps::REST::Users#post => Started'

        raise "Can't post without a REST Client" unless @client

        response, error_messages = @client.post(end_point, params)

        user = response.present? ? User.new(response.body) : nil
        @logger.debug "FinApps::REST::Users#post => user: #{user.pretty_inspect}" if user.present?

        @logger.debug 'FinApps::REST::Users#post => Completed'

        return user, error_messages
      end

    end

    class User < FinApps::REST::Base
      attr_accessor :public_id, :token, :email, :first_name, :last_name, :postal_code
    end

  end
end