module FinApps
  module REST

    class Accounts
      include FinApps::REST::Defaults

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Accounts]
      def initialize(client)
        @client = client
        @logger = client.logger
        @logger.debug 'FinApps::REST::Accounts => initialized'
      end

      # @param [Hash] params
      # @return [FinApps::REST::Account, Array]
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
        @logger.debug 'FinApps::REST::Accounts#post => Started'

        raise "Can't post without a REST Client" unless @client

        response, error_messages = @client.post(end_point, params)

        account = response.present? ? Account.new(response.body) : nil
        @logger.debug "FinApps::REST::Accounts#post => user: #{account.pretty_inspect}" if account.present?

        @logger.debug 'FinApps::REST::Accounts#post => Completed'

        return account, error_messages
      end

    end

    class Account < FinApps::REST::Base
      attr_accessor :public_id
    end

  end
end