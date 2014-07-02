module FinApps
  module REST

    class Users
      include FinApps::REST::Defaults

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Users]
      def initialize(client)
        @client = client
      end

      # @param [Hash] params
      # @return [FinApps::REST::User, Array]
      def create(params = {})
        raise "Can't create a resource without a REST Client" unless @client

        post(END_POINTS[:users_create], params)
      end

      # @param [Hash] params
      # @return [FinApps::REST::User]
      def login(params = {})
        raise "Can't login without a REST Client" unless @client

        post(END_POINTS[:users_login], params)
      end

      private

      def post(end_point, params={})
        response, error_messages = @client.post(end_point, params)
        return Users.faraday_response_to_user(response) , error_messages
      end

      def self.faraday_response_to_user(response)
        if response.respond_to? :body
          user_hash = response.body

          user = User.new(user_hash.public_id, user_hash.token)
          user.update_from_hash user_hash
        end
      end

    end

    class User < FinApps::REST::Base
      attr_accessor :email, :first_name, :last_name, :postal_code
      attr_reader :public_id, :token

      def initialize(public_id=nil, token=nil)
        @public_id = public_id
        @token = token
      end

    end

  end
end